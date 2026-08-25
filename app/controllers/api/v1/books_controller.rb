module Api
  module V1
    class BooksController < Api::V1::ApiV1Controller
      before_action :set_book, only: [ :show, :update ]

      after_action :verify_authorized, except: [ :index ]
      after_action :verify_policy_scoped, only: [ :index ]


      def index
        evaluated = paginate_params[:keywords].blank? ? policy_scope(Book) : policy_scope(Book).search(paginate_params[:keywords])
        data, meta = self.class.paginator(evaluated, paginate_params) do |item|
         BookSerializer.new(item)
        end

        render json: { data: data, meta: meta }, adapter: nil
      end

      def show
        authorize @book
        # UserReadBookJobs.perform_later(@current_user[:id], @book.id)
        scope = { include: [ :author ] }
        scope[:categories] = JSON.parse(@book.categories) if @book&.categories
        render json: @book, scope: scope
      end

      def update
        authorize @book
        @book.update(item_params)
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

      def item_params
        params.require(:book).permit(:title, :description)
      end
    end
  end
end
