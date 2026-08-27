module Api
  module V1
    class SessionsController < Api::V1::ApiV1Controller
      include Tokens
      include Authenticator

      skip_before_action :authenticated_request, only: [ :create ]

      def create
        val = params[:email] || params[:username]
        raise BusinessException.new("400|Username or email is required") if val.blank?

        user = User.find_by_email_or_username(val: val.downcase, cacheable: true)

        raise BusinessException.new(ErrorMessages::INVALID_CREDENTIALS) unless user&.authenticate(params[:password])
        access_token = self.class.create_tokens(user)
        render json: { access_token: access_token.token, expires_at: access_token.expires_at }, status: :ok
      end

      def destroy
        self.class.logout!(user: current_user)
        head :no_content
      end
    end
  end
end
