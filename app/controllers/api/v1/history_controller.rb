module Api
  module V1
    class HistoryController < Api::V1::ApiV1Controller
      before_action :set_history, only: [ :show, :destroy ]
      after_action :verify_authorized

      def growth
        authorize User
          period = params[:period] || Consts::PeriodEnum::MONTH
          puts period
          stat = BookView.growth(BookView, period)
          render json: stat.to_h
      end

      def chart
        authorize User
          period = params[:period] || Consts::PeriodEnum::MONTH
          puts period
          stat = BookView.chart(BookView.active, period)
          render json: stat.to_h
      end

      def index
        authorize BookView
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
        authorize @book_view
        render json: @book_view
      end

      def destroy
        authorize @book_view
        @book_view.destroy
        head :no_content
      end

      def destroy_all
        authorize BookView
        BookView.clear_history(current_user.id)
        head :no_content
      end

      private
      def set_history
        id = params[:id]
        is_exists = BookView.by_id(id).first
        raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND, id) unless is_exists.present?
        @book_view = is_exists
      end
    end
  end
end
