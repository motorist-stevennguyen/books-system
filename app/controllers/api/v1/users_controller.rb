module Api
  module V1
    class UsersController < Api::V1::ApiV1Controller
      # before_action :set_user, only: [ :show, :update, :destroy, :profile ]

      # GET /users
      def index
        @users = User.all
        render json: @users
      end

      def history
        authorize @current_user
        keywords = paginate_params[:keywords]
        viewed_books = BookView.load_book.find_by_uid(@current_user.id)
        viewed_books = keywords.blank? ? viewed_books : viewed_books.search(keywords)
        opts = paginate_params
        opts["order_by"] = "book_views.created_at"
        opts["sorted"] = "desc"
        data, meta = self.class.paginator(viewed_books, opts) do |item|
          BookViewSerializer.new(item, scope: { include: [ :book ] })
        end
        render json: { data: data, meta: meta }, adapter: nil
      end

      def profile
        user = User.find_by_email_or_username(val: current_user[:username], cacheable: true)
        render json: user
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
