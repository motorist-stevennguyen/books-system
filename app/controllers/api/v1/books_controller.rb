module Api
  module V1
    class BooksController < Api::V1::ApiV1Controller
      before_action :set_book, only: [ :show, :update, :destroy ]

      after_action :verify_authorized, except: [ :index ]
      after_action :verify_policy_scoped, only: [ :index ]


      def index
        opts = filterd_params
        keywords = opts[:keywords]
        opts[:order_by] = "books.created_at"
        evaluated = keywords.blank? ? policy_scope(Book) : policy_scope(Book).search(keywords)

        data, meta = self.class.paginator(evaluated.eager_load(:author), opts) do |item|
          BookSerializer.new(item, scope: { include: [ :author ] })
        end

        render json: { data: data, meta: meta }, adapter: nil
      end

      def create
        authorize Book
        book = Book.new(book_params)
        book.save!

        render json: book
      end

      def show
        authorize @book
        scope = { include: [ :author ] }
        scope[:categories] = JSON.parse(@book.categories) if @book&.categories
        UserReadBookJobs.perform_later(@current_user[:id], @book.id)
        render json: @book, scope: scope
      end

      def update
        authorize @book
        @book.update(book_params)
        render json: @book
      end

      def destroy
        authorize @book
        @book.update_attribute(:status, StatusConst::DELETED)
        render json: @book
      end

      private
      def show_params
        params.expect(:id)
      end

      def set_book
        id = params[:id]
        exists = Book.eager_load(:author).find_by_id(id)
        raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND) unless exists.present?
        @book = exists
      end

      def book_params
        params
        .require(:book)
        .permit(:title, :language, :pages, :published_date, :author_id, :cover_url, :description, :status, category_ids: [])
      end
    end
  end
end
