module Api
  module V1
    class UsersController < Api::V1::ApiV1Controller
      before_action :set_user, only: [ :show, :destroy, :update ]
      after_action :verify_authorized

      # ADMIN
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

      def destroy
        authorize @user
        @user.destroy
        render json: { message: "Done" }
      end

      # USER
      def update_profile
        authorize @current_user
        @current_user.update(profile_params)
        render json: @current_user
      end

      def history
        authorize @current_user
        opts = filterd_params
        keywords = opts[:keywords]
        viewed_books = BookView.load_book.find_by_uid(@current_user.id)
        viewed_books = keywords.blank? ? viewed_books : viewed_books.search(keywords)
        opts["order_by"] = "book_views.created_at"
        opts["sorted"] = "desc"

        data, meta = self.class.paginator(viewed_books, opts) do |item|
          BookViewSerializer.new(item, scope: { include: [ :book ] })
        end
        render json: { data: data, meta: meta }, adapter: nil
      end

      def profile
        authorize User
        user = User.find_by_email_or_username(val: current_user[:username])
        render json: user
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
