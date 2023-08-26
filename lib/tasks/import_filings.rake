desc "Import filings"
namespace :filings do
  task import: [:environment] do
    paths = [
      '990-xmls/201612429349300846_public.xml',
      '990-xmls/201831309349303578_public.xml',
      '990-xmls/201641949349301259_public.xml',
      '990-xmls/201921719349301032_public.xml',
      '990-xmls/202141799349300234_public.xml',
      '990-xmls/201823309349300127_public.xml',
      '990-xmls/202122439349100302_public.xml',
      '990-xmls/201831359349101003_public.xml',
    ]
    # Follow-ups:
    #  - Logging for each step: stream out to something like Sumo and attach alerts/monitoring
    #  - Data integrity checks (e.g. is the address complete?)
    #
    # Here what I want to illustrate is how I'm thinking of these stages as parallelisable
    # processes that could deployed on something like AWS via SQS and Lambda.
    #
    # Step 1: Fetch the raw XML and parse it
    # Note: An improvement here would be to build out logic for graceful handling of failures
    #       i.e. In a parallel fetch we may want to skip any failures and continue to process the successful requests
    #       Then if there are failures we could queue them for a retry
    puts ::Filings::FilingServiceClient.new.fetch_all(paths)
      # Step 2: Serialize the returns data
      .map(&::Filings::SerializeReturns)
      # Step 3: Determine which amendment should be processed
      # Note: Potential improvement would be to filter amendments prior to serializing
      .reduce({}, &::Filings::FindLatestAmendment)
      .values
      # Step 4: Insert the data into the DB
      .map(&::Filings::HydrateDb)
  end
end