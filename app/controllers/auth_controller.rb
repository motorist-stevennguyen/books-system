class AuthController < ApplicationController
  def register
    args = signup_args
    
  end

  private
  def signup_args
    params.require(:signup_args).permit(:username, :email, :password, :confirm_password)
  end
end
