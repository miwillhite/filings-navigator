module Api
  module V1
    class AwardsController < ApplicationController
      before_action :load_awards, only: :index

      def index
        render json: @awards.as_json
      end

      private def load_awards
        @awards = Award.all.includes(:recipient)
        @awards = @awards.by_filing(params[:filing_id]) if params[:filing_id]
        @awards = @awards.filter_by_cash_amount(min: params[:cash_amount_min], max: params[:cash_amount_max]) if params[:cash_amount_min].present? || params[:cash_amount_max].present?
        # @awards = @awards.limit(params[:per_page]) # TODO pagination
      end
    end
  end
end