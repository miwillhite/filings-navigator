# Usage: Filings::FilingServiceClient.fetch_all(['990-xmls/201612429349300846_public.xml'])
#
# Note: I was having trouble getting this Faraday middleware to work, so I tabled it
# class ParseXmlResponse < Faraday::Middleware
#   def on_complete(env)
#     Nokogiri::XML(env.body)
#   end
# end
# Faraday::Response.register_middleware(xml: ParseXmlResponse)

module Filings
  class FilingServiceClient
    def initialize
      @conn = Faraday.new(url: 'https://filing-service.s3-us-west-2.amazonaws.com', headers: { 'Content-Type' => 'application/xml' })
    end

    # TODO
    # - fetch multiple paths in parallel
    # - add logger
    def fetch_all(paths)
      # TODO Make parallel
      paths.map { |path| @conn.get(path) }.map(&:body).map { |body| Nokogiri::XML(body) }
    end
  end
end