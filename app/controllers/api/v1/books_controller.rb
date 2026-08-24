module Api
  module V1
    class BooksController < Api::V1::ApiV1Controller
      after_action :verify_authorized, except: [ :index ]

      before_action :set_book, only: [ :show ]

      def index
      end

      def show
        authorize @book
        # UserReadBookJobs.perform_later(@current_user[:id], @book.id)
        render json: @book, scope: {categories: JSON.parse(@book.categories), include: [:author]}
      end

      private
      def show_params
        params.expect(:id)
      end

      def set_book
        id = params[:id]
        @book = Book.eager_load(:author).find_by_id(id)
      end
    end
  end
end
