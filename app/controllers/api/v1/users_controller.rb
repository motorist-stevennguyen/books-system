module Api
  module V1
    class UsersController < Api::V1::ApiV1Controller
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /users
      def index
        @users = User.all
        render json: @users
      end

      # GET /users/:id
      def show
        render json: @user
      end

      # POST /users
      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end
end