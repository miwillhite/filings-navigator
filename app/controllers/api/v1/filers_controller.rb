module Api
  module V1
    class FilersController < ApplicationController
      before_action :load_filers, only: :index

      def index
        # TODO Use a serializer
        render json: @filers.as_json
      end

      private def load_filers
        @filers = Filer.all.includes(:address)
        @filers = @filers.filter_by_state(params[:state]) if params[:state]
        # @filers = @filers.limit(params[:per_page]) TODO pagination
      end
    end
  end
end