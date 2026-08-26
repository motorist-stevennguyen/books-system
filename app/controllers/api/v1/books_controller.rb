module Api
  module V1
    class BooksController < Api::V1::ApiV1Controller
      before_action :set_book, only: [ :show, :update, :destroy ]

      after_action :verify_authorized, except: [ :index ]
      after_action :verify_policy_scoped, only: [ :index ]


      def index
        keywords = paginate_params[:keywords]
        evaluated = keywords.blank? ? policy_scope(Book) : policy_scope(Book).search(keywords)
        # author_ids = evaluated.pluck(:author_id)

        # mapped_authors = {}
        # Author.where("id in (?)", author_ids).to_a.each do |author|
        #   mapped_authors["#{author.id}"] = AuthorSerializer.new(author)
        # end

        data, meta = self.class.paginator(evaluated, paginate_params) do |item|
          BookSerializer.new(item)
        end

        # data = data.map do |item|
        #   json_item = item.as_json
        #   json_item["author"] = mapped_authors["#{json_item.fetch(:author_id)}"]
        #   json_item
        # end

        render json: { data: data, meta: meta }, adapter: nil
      end

      def create
        authorize Book
        book = Book.new(book_params)
        book.save!

        rescue => e
          raise BusinessException.new("400|#{e.message}")

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
        @book.update(item_params)
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

      def item_params
        params.require(:book).permit(:title, :description)
      end

      def book_params
        params
        .require(:book)
        .permit(:title, :language, :pages, :published_date, :author_id, :cover_url, :description, :status, category_ids: [])
      end
    end
  end
end
