module Api
  module V1
    class HistoryController < Api::V1::ApiV1Controller
      before_action :set_history, only: [ :show, :destroy, :destroy_all ]
      after_action :verify_authorized

      # ADMIN
      def index
        authorize User
        opts = paginate_params
        keywords = opts[:keywords]
        viewed_books = BookView.load_book.by_uid(current_user.id)
        viewed_books = keywords.blank? ? viewed_books : viewed_books.search(keywords)
        opts["order_by"] = "book_views.created_at"
        opts["sorted"] = "desc"

        data, meta = HistoryController.paginator(viewed_books, opts) do |item|
          BookViewSerializer.new(item, scope: { include: [ :book ] })
        end
        render json: { data: data, meta: meta }, adapter: nil
      end

      def show
        authorize book_view
        render json: book_view
      end

      def destroy
        authorize book_view
        book_view.destroy
        head :no_content
      end

      def destroy_all
        authorize User
        BookView.clear_history(current_user.id)
        head :no_content
      end

      private
      def set_history
        id = params[:id]
        is_exists = BookView.by_id(id: id)
        raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND, id) unless is_exists.present?
        @book_view = is_exists
      end
    end
  end
end
