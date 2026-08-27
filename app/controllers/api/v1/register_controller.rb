module Api
  module V1
    class RegisterController < ApiV1Controller
      include Tokens

      def create
        user = User.new(register_params)
        if user.save!
          access_token = self.class.create_tokens(user)
          render json: { access_token: access_token, user_id: user[:id] }, status: :ok
        end
      rescue => e
        raise BusinessException.new("400|#{e.record.errors.full_messages.join(', ')}")
      end

      private
      def register_params
        params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
      end
    end
  end
end
