module Api
  module V1
    class CategoriesController < Api::V1::ApiV1Controller
      before_action :set_category, only: [ :show, :update, :destroy ]
      after_action :verify_policy_scoped, only: [ :index ]

      def index
        evaludated = policy_scope(Category)
        data, meta = self.class.paginator(evaludated, paginate_params) do |item| CategorySerializer.new(item) end
        render json: { data: data, meta: meta }, adapter: nil
      end

      def create
        authorize Book
        item = Category.new(category_params)
        render json: item if item.save
        raise BusinessException.new(ErrorMessages::FAILED_TO_SAVE_RECORD)
      end

      def show
        authorize @category
        render json: @category
      end

      def update
        authorize @category
        @category.update(category_params)
        render json: @category
      end

      def destroy
        authorize @category
        @category.destroy
        head :no_content
      end

      private
      def set_category
        exists = Category.find_by_id(params[:id])
        raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND) unless exists.present?
        @category = exists
      end
      def category_params
        params.require(:category).permit(:name, :slug, :description)
      end
    end
  end
end
