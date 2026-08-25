module Pagination
  extend ActiveSupport::Concern
      included do
        before_action :paginate_params, only: [ :index ]

        private
        def paginate_params
            params.permit(:page, :take, :sorted, :order_by).reverse_merge({ page: 1, take: 5, order_by: "created_at", sorted: "asc" })
        end
      end

      class_methods do
        def paginator(relation, opts)
          take = opts[:take].to_i
          page = opts[:page].to_i

          paginated = relation.order("#{opts[:order_by]} #{opts[:sorted].upcase}").limit(take+1).offset(take * (page > 0 ? page - 1 : 1)).to_a
          has_next = paginated.length == take+1
          paginated.pop if has_next

          data = paginated.map do |item|
           yield item
          end

          [ data, {
            page: page,
            take: take,
            number_of_record: paginated.length,
            has_next: has_next
          } ]
        end
      end
end
