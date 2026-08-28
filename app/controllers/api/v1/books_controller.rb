module Api
  module V1
    class BooksController < Api::V1::ApiV1Controller
      before_action :set_book, only: [ :show, :update, :destroy ]

      after_action :verify_authorized, except: [ :index, :growth, :chart, :destroy_many ]
      after_action :verify_policy_scoped, only: [ :index ]

      def growth
        authorize User
          period = params[:period] || Consts::PeriodEnum::MONTH
          puts period
          stat = Book.growth(Book, period)
          render json: stat.to_h
      end

      def chart
        authorize User
        period = params[:period] || Consts::PeriodEnum::MONTH
        stat = Book.chart(Book, period)
        render json: stat.to_h
      end

      def index
        opts = paginate_params
        keywords = opts[:keywords]
        evaluated = keywords.blank? ? policy_scope(Book) : policy_scope(Book).search(keywords)

        opts[:order_by] = "books.#{opts[:order_by]}"

        data, meta = BooksController.paginator(evaluated.eager_load(:author), opts) do |item|
          BookSerializer.new(item, scope: { include: [ :author ] })
        end

        render json: { data: data, meta: meta }, adapter: nil

      rescue => e
        raise BusinessException.new("400|#{e.message}")
      end

      def create
        authorize Book
        item = Book.new(item_params)
        render json: item if item.save!
      rescue => e
        raise BusinessException.new(ErrorMessages::FAILED_TO_SAVE_RECORD, e&.message)
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
        @book.update(item_params)
        render json: @book
      end

      def destroy
        authorize @book
        @book.update_attribute(:status, StatusConst::DELETED)
        head :no_content
      end

      def destroy_many
        authorize Book
        ids = delete_ids[:ids].to_a || []
        raise BusinessException.new(ErrorMessages::PARAMS_IS_INVALID) if ids.length < 1
        Book.destroy_many(ids)
        head :no_content
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
        params
        .require(:book)
        .permit(:title, :language, :pages, :published_date, :author_id, :cover_url, :description, :status, category_ids: [])
      end

      def delete_ids
        params
        .require(:delete)
        .permit(ids: [])
      end
    end
  end
end
