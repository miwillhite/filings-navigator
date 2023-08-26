module Filings
  class SerializeReturns
    # Note: I don't actually use this a lot in real code, but I like how it let's us pass in a "service" to an enumerator
    def self.to_proc
      -> (args) { new(args).run }
    end

    def initialize(parsed_xml)
      @parsed_xml = parsed_xml
    end

    # Note: Participant schema paths are relative to the RecipientTable node
    COMMON = {
      filer_address_city: %w[Return ReturnHeader Filer USAddress CityNm],
      filer_address_postal_code: %w[Return ReturnHeader Filer USAddress ZIPCd],
      filer_address_state: %w[Return ReturnHeader Filer USAddress StateAbbreviationCd],
      filer_address_street_1: %w[Return ReturnHeader Filer USAddress AddressLine1Txt],
      filer_business_name: %w[Return ReturnHeader Filer BusinessName BusinessNameLine1Txt],
      filer_ein: %w[Return ReturnHeader Filer EIN],
      amended_return_indicator: %w[Return ReturnData IRS990 AmendedReturnInd],
      award_amount: %w[CashGrantAmt],
      award_purpose: %w[PurposeOfGrantTxt],
      recipient_address_city: %w[USAddress CityNm],
      recipient_address_postal_code: %w[USAddress ZIPCd],
      recipient_address_state: %w[USAddress StateAbbreviationCd],
      recipient_address_street_1: %w[USAddress AddressLine1Txt],
      recipient_business_name: %w[RecipientBusinessName BusinessNameLine1Txt],
      recipient_ein: %w[RecipientEIN],
      recipient_table: %w[Return ReturnData IRS990ScheduleI RecipientTable],
      return_timestamp: %w[Return ReturnHeader ReturnTs],
      tax_period_end: %w[Return ReturnHeader TaxPeriodEndDt],
      tax_period_start: %w[Return ReturnHeader TaxPeriodBeginDt],
    }
    
    # Explicitly define the schemas, though many of them use the same structure
    SCHEMA_2015_V2_1 =
    SCHEMA_2016_V3_0 =
    SCHEMA_2017_V2_2 =
    SCHEMA_2018_V3_1 =
    SCHEMA_2020_V4_1 = COMMON

    SCHEMA_2017_V2_3 = 
    SCHEMA_2020_V4_0 = COMMON.merge(
      award_amount: %w[Amt],
      award_purpose: %w[GrantOrContributionPurposeTxt],
      recipient_table: %w[Return ReturnData IRS990PF SupplementaryInformationGrp GrantOrContributionPdDurYrGrp],
    )

    def run
      # TODO: Report if we encounter an undefined schema
      schema_version = search(path: %w[Return], node: @parsed_xml)[0].attributes['returnVersion'].value
      schema = case schema_version
               when '2015v2.1'
                 SCHEMA_2015_V2_1
               when '2016v3.0'
                 SCHEMA_2016_V3_0
               when '2017v2.2'
                 SCHEMA_2017_V2_2
               when '2017v2.3'
                 SCHEMA_2017_V2_3
               when '2018v3.1'
                 SCHEMA_2018_V3_1
               when '2020v4.0'
                 SCHEMA_2020_V4_0
               when '2020v4.1'
                 SCHEMA_2020_V4_1
               end

      # Pull out top-level attributes that are needed for the awards
      amended_return = get_text(path: schema[:amended_return_indicator], node: @parsed_xml).present?
      return_timestamp = get_text(path: schema[:return_timestamp], node: @parsed_xml)
      tax_period_end = get_text(path: schema[:tax_period_end], node: @parsed_xml)
      tax_period_start = get_text(path: schema[:tax_period_start], node: @parsed_xml)

      # Initialize our output
      output = {
        meta: {
          amended_return:,
          return_timestamp:,
          schema_version:,
          tax_period_end:,
          tax_period_start:,
        }
      }

      # Gather the recipient + award data
      output[:recipients] = search(path: schema[:recipient_table], node: @parsed_xml).map do |recipient|
        {
          ein: schema[:recipient_ein],
          business_name: schema[:recipient_business_name],
          address: {
            street1: get_text(path: schema[:recipient_address_street_1], node: recipient),
            city: get_text(path: schema[:recipient_address_city], node: recipient),
            state: get_text(path: schema[:recipient_address_state], node: recipient),
            postal_code: get_text(path: schema[:recipient_address_postal_code], node: recipient),
          },
          award: {
            amount_in_dollars: get_text(path: schema[:award_amount], node: recipient),
            purpose: get_text(path: schema[:award_purpose], node: recipient),
          }
        }.transform_values { |value| value.is_a?(Array) ? get_text(path: value, node: recipient) : value }
      end.reject { |recipient| recipient[:award][:amount_in_dollars].blank? } # Some award data is given without a recipient ???

      # Gather the filer data
      output[:filer] = {
        ein: get_text(path: schema[:filer_ein], node: @parsed_xml),
        business_name: get_text(path: schema[:filer_business_name], node: @parsed_xml),
        address: {
          street1: get_text(path: schema[:filer_address_street_1], node: @parsed_xml),
          city: get_text(path: schema[:filer_address_city], node: @parsed_xml),
          state: get_text(path: schema[:filer_address_state], node: @parsed_xml),
          postal_code: get_text(path: schema[:filer_address_postal_code], node: @parsed_xml),
        },
      }

      output
    end

    private def get_text(path:, node:)
      search(path:, node:).text
    end

    private def search(path:, node:)
      # FIXME: There is probably a better way in Nokogiri to prepend a global namespace!
      node.xpath("n:#{path.join('/n:')}", n: 'http://www.irs.gov/efile')
    end
  end
end
