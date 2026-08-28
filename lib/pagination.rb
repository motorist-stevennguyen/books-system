module Pagination
  extend ActiveSupport::Concern
      def paginate_params(*params_name)
        valid = params.permit(:page, :take, :sorted, :order_by, :keywords, *params_name).reverse_merge({ keywords: "", page: 1, take: 5, order_by: "created_at", sorted: "desc" })
        take = valid[:take].to_i || 0

        raise BusinessException.new(ErrorMessages::PARAMS_IS_INVALID, "sorted(#{valid[:sorted]})") unless Consts::SortedEnum.valid?(valid[:sorted])
        raise BusinessException.new(ErrorMessages::PARAMS_IS_INVALID, "order_by(#{valid[:order_by]})") unless Consts::OrderBy.valid?(valid[:order_by])
        raise BusinessException.new(ErrorMessages::PARAMS_IS_INVALID, "take(#{valid[:take]}) must be in 1..100") if take > 100 || take.to_i < 1

        valid
      end

      class_methods do
        def paginator(relation, opts)
          take = opts[:take].to_i
          page = opts[:page].to_i

          paginated = relation
          .order("#{opts[:order_by]} #{opts[:sorted].upcase}")
          .limit(take+1)
          .offset(take * (page > 0 ? page - 1 : 1)).to_a

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
