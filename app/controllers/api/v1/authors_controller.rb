module Api
  module V1
    class AuthorsController < Api::V1::ApiV1Controller
      before_action :set_author, only: [ :show, :update, :destroy ]

      def index
        evaludated = policy_scope(Author)
        data, meta = self.class.paginator(evaludated, paginate_params) do |item|
         AuthorSerializer.new(item)
        end

        render json: { data: data, meta: meta }, adapter: nil
      end

      def show
        render json: @author
      end

      def update
        authorize @author
        @author.update(item_params)
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
        raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND) if exists.present?
        exists
      end

      def item_params
        params(:author).permit(:bio, :birth_date, :name, :nationality)
      end
    end
  end
end
