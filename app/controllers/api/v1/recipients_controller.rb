module Api
  module V1
    class RecipientsController < ApplicationController
      before_action :load_recipients, only: :index

      def index
        # TODO Use a serializer
        render json: @recipients.as_json
      end

      private def load_recipients
        @recipients = Recipient.all.includes([:address, :awards])
        @recipients = @recipients.filter_by_state(params[:state]) if params[:state]
        @recipients = @recipients.filter_by_cash_amount(min: params[:cash_amount_min], max: params[:cash_amount_max]) if params[:cash_amount_min].present? || params[:cash_amount_max].present?
        @recipients = @recipients.filter_by_filing(params[:filing_id]) if params[:filing_id]
        # @recipients = @recipients.limit(params[:per_page]) # TODO pagination
      end
    end
  end
end