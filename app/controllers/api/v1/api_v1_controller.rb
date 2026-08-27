module Api
  module V1
    class ApiV1Controller < ApplicationController
      include Pundit::Authorization
      include Api::Concerns::JsonRequest
      include Pagination
      include Authenticator

      before_action :authenticated_request

      rescue_from StandardError do |exception|
        case exception.instance_of?(Pundit::NotAuthorizedError)
        when true
          message, code = ErrorMessages::ACCESS_DENIED.split("|")
          render json: { error: message, code: code }, status: :bad_request
        else
          render json: { error: exception.message, code: exception.code.to_i }, status: :bad_request
        end
      end

      private

      attr_reader :current_user

      def authenticated_request
        @current_user = self.class.authenticated(headers: request.headers, at: request.headers["Authorization"]&.split(" ")&.last)
        Rails.logger.info("[#{self.class}] #{current_user[:uid]} #{current_user[:email]}")
      end
    end
  end
end
