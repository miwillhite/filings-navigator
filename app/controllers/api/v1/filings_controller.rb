module Api
  module V1
    class FilingsController < ApplicationController
      before_action :load_filings, only: :index

      def index
        render json: @filings.as_json
      end

      private def load_filings
        @filings = Filing.all.includes(:filer)
        @filings = @filings.by_filer(params[:filer_id]) if params[:filer_id]
        # @filings = @filings.limit(params[:per_page]) TODO pagination
      end
    end
  end
end