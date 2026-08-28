module Api
  module V1
    class UsersController < Api::V1::ApiV1Controller
      before_action :set_user, only: [ :show, :destroy, :update ]
      after_action :verify_authorized

      # ADMIN
      def growth
          authorize User
          period = params[:period] || Consts::PeriodEnum::MONTH
          stat = User.growth(User, period)
          render json: stat.to_h
      end

      def chart
          authorize User
          period = params[:period] || Consts::PeriodEnum::MONTH
          puts period
          stat = User.chart(User.active, period)
          render json: stat.to_h
      end

      def index
        authorize User
        keywords = paginate_params[:keywords]
        filtered_users = keywords.blank? ? User : User.search(keywords)
        data, meta = self.class.paginator(filtered_users, paginate_params) do |item|
          UserSerializer.new(item)
        end

        render json: { data: data, meta: meta }
      end

      def update
          authorize @user
          @user.update(user_params)
          render json: @user
      end

      def show
        authorize @current_user
        render json: @user
      end

      def disabled
        authorize User
        current_user.update(status: StatusConst::DELETED)
        head :no_content
      end

      def destroy
        authorize User
        @user.destroy
        head :no_content
      end

      # USER
      def update_profile
        authorize @current_user
        @current_user.update(profile_params)
        render json: @current_user
      end

      def profile
        authorize User
        render json: current_user
      end

      private

      def set_user
          id = params[:id]
          is_exists = User.find_by_id(id: id)
          raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND, id) unless is_exists.present?
          @user = is_exists
      end

      def user_params
          params.require(:user).permit(:first_name, :last_name)
      end

      def profile_params
          params.require(:user).permit(:first_name, :last_name)
      end
    end
  end
end
