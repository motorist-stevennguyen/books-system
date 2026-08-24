module Api
  module V1
    class SessionsController < Api::V1::ApiV1Controller
      include Jwt
      include Authenticator

      skip_before_action :authenticated_request, only: [:login]

      # POST /api/v1/auth/login
      def login
        val = params[:email] || params[:username]
        raise BusinessException.new("400|Username or email is required") if val.blank?

        user = User.find_by_email_or_username(val: val.downcase, cacheable: true)

        unless user&.authenticate(params[:password])
          return render json: { error: "Invalid email or password" }, status: :unauthorized
        end

        access_token = self.class.create_tokens(user)
        render json: { access_token: access_token, user_id: user[:id] }, status: :ok
      end

      # DELETE /api/v1/auth/logout
      def logout
        self.class.logout!(user: current_user)
        head :no_content
      end
    end
  end
end
