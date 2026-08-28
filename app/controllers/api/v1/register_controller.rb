module Api
  module V1
    class RegisterController < Api::V1::ApiV1Controller
      include Tokens

      skip_before_action :authenticated_request

      def create
        user = User.new(register_params)
        if user.save!
          access_token = self.class.create_tokens(user)
          render json: { access_token: access_token.token, expires_at: access_token.expires_at }, status: :ok
        end
      rescue => e
          raise BusinessException.new(ErrorMessages::FAILED_TO_SAVE_RECORD, e&.message)
      end

      private
      def register_params
        params.require(:register).permit(:first_name, :last_name, :username, :email, :password, :confirmation_password)
      end
    end
  end
end
