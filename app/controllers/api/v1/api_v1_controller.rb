module Api
  module V1
    class ApiV1Controller < ApplicationController
      include Pundit::Authorization
      include Api::Concerns::JsonRequest
      include Authenticator

      before_action :authenticated_request

      rescue_from StandardError do |exception|
        render json: { error: exception.message, code: exception.code.to_i }, status: :bad_request
      end

      private

      attr_reader :current_user, :decoded_token

      def authenticated_request
        @current_user, @decoded_token = self.class.authenticated(headers: request.headers, at: request.headers["Authorization"]&.split(" ")&.last)
        Rails.logger.info("[#{self.class}] #{current_user[:uid]} #{current_user[:email]}")
      end
    end
  end
end
