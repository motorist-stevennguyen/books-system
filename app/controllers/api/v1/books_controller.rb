module Api
  module V1
    class BooksController < Api::V1::ApiV1Controller
      after_action :verify_authorized, excep: [ :index ]

      before_action :set_book, only: [ :show ]

      def index
      end

      def show
        authorize @book
        # categories = Book.find_book_categories(@book.id)
        # categories = BookCategory.find_categories_by_book(@book.id)
        # UserReadBookJobs.perform_later(@current_user[:id], @book.id)
        puts "Categories: ", @book

        render json: @book
      end

      private
      def show_params
        params.expect(:id)
      end

      def set_book
        id = params[:id]
        @book = Book.eager_load(:author).find_full_book(id)
      end
    end
  end
end
