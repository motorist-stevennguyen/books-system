module Api
  module V1
    class RegisterController < ApiV1Controller
      include Tokens

      def create
        @user = User.new(register_params)
        if @user.save!
          render json: @user, status: :created
        end
      rescue => e
        raise BusinessException.new("400|#{e.record.errors.full_messages.join(', ')}")
      end

      private

      def register_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
    end
  end
end
