module Filings
  class FindLatestAmendment
    def self.to_proc
      -> (returns, ret) { new(returns, ret).returns }
    end

    attr_accessor :returns

    def initialize(returns, ret)
      self.returns = returns.clone # Shallow copy is fine here
      ein = ret[:filer][:ein]
      if self.returns[ein].nil? || latest_amendment?(new_return: ret, existing_return: self.returns[ein])
        self.returns[ein] = ret
      end
    end

    private def latest_amendment?(new_return:, existing_return:)
      # Look at the amended tax return indicator
      new_return[:meta][:amended_return] &&
      # and the date of the return to determine which to use
      new_return[:meta][:return_timestamp] > existing_return[:meta][:return_timestamp]
    end
  end
end
