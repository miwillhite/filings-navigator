module Filings
  module Service
    extend self

    def create(params:)
      ActiveRecord::Base.transaction do
        # Build out Filing
        filing = ::Filing.create!(
          return_timestamp: params[:meta][:return_timestamp],
          tax_period_end: params[:meta][:tax_period_end],
          tax_period_start: params[:meta][:tax_period_start],
        )

        # Buid out Filer
        filer = ::Filer.find_or_initialize_by(ein: params[:filer][:ein])
        filer.business_name = params[:filer][:business_name]
        filer.address = ::Address.new(params[:filer][:address])
        filer.filing = filing
        filer.save!

        # Build out Recipients and Awards
        params[:recipients].each do |recipient_params|
          # Recipient
          recipient = ::Recipient.find_or_initialize_by(ein: recipient_params[:ein], business_name: recipient_params[:business_name])
          recipient.business_name = recipient_params[:business_name]
          recipient.filing = filing

          # Address
          recipient.build_address(recipient_params[:address])
          recipient.save!

          # Award
          award = ::Award.new(recipient_params[:award])
          award.recipient = recipient
          award.save!
        end

        [filer.id, filer.business_name]
      end

    rescue => e
      puts e.message
      print e.backtrace.join("\n")
      # Do something
    end
  end
end