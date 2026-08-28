module Api
  module V1
    class AuthorsController < Api::V1::ApiV1Controller
      before_action :set_author, only: [ :show, :destroy, :update ]

      def create
        authorize Author
        item = Author.new(author_params)
        render json: item if item.save
        raise BusinessException.new(ErrorMessages::FAILED_TO_SAVE_RECORD)
      end

      def index
        authorize Author
        data, meta = AuthorsController.paginator(Author, paginate_params) do |item|
         AuthorSerializer.new(item)
        end

        render json: { data: data, meta: meta }
      end

      def show
        authorize Author
        render json: @author
      end

      def update
        authorize author
        author.update(author_params)
        render json: @author
      end

      def destroy
        authorize @author
        @author.destroy
        head :no_content
      end

      private
      def set_author
        exists = Author.find_by_id(params[:id])
        raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND) unless exists.present?
        @author = exists
      end

      def author_params
        params.require(:author).permit(:bio, :birth_date, :name, :nationality)
      end
    end
  end
end
