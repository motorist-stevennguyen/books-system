module Api
  module V1
    class ApiV1Controller < ApplicationController
      include Pundit::Authorization
      include Authenticator
      include Pagination

      before_action :authenticated_request

      rescue_from StandardError do |exception|
        case exception.instance_of?(BusinessException)

        when true
          render json: { error: exception.message, code: exception.code.to_i }, status: :bad_request
        else
          render json: { error: exception.message, code: "400" }, status: :bad_request
        end
      end

      private

      attr_reader :current_user

      def authenticated_request
        @current_user = ApiV1Controller.authenticated(request.headers)
        Rails.logger.info("[#{self.class}] #{current_user[:uid]} | #{current_user.role} - #{current_user[:email]}")
      end
    end
  end
end
