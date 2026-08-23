module Api
  module V1
    class SessionsController < Api::V1::ApiV1Controller
      include Jwt
      include Authenticator

      skip_before_action :authenticated_request, only: %i[login refresh]

      # POST /api/v1/auth/login
      def login
        val = params[:email] || params[:username]
        raise BusinessException.new("400|Username or email is required") if val.blank?
        login_with = val.to_s.include?("@") ? "email" : "username"

        user = User.find_by_email_or_username(val: val.downcase, cacheable: true)

        unless user&.authenticate(params[:password])
          return render json: { error: 'Invalid email or password' }, status: :unauthorized
        end

        access_token, refresh_token = self.class.create_tokens(user, login_with)
        render json: { access_token: access_token, refresh_token: refresh_token, user_id: user[:id] }, status: :ok
      end

      # POST /api/v1/auth/refresh
      def refresh
        user = User.find_by(id: params[:user_id])
        return render json: { error: 'Invalid user' }, status: :unauthorized unless user

        new_access_token, new_refresh_token = self.class.refresh!(
          refresh_token: params[:refresh_token],
          access_token: params[:access_token],
          user: user
        )

        render json: { access_token: new_access_token, refresh_token: new_refresh_token }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unauthorized
      end

      # DELETE /api/v1/auth/logout
      def logout
        self.class.logout!(user: current_user, decoded_token: decoded_token)
        head :no_content
      end
    end
  end
end