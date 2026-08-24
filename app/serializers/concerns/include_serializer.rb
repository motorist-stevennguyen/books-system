module IncludeSerializer
  extend ActiveSupport::Concern

  class_methods do
    def include_attr?(scope, attr)
      return false unless scope.present?
      include = scope[:include] || []
      include.include?(attr)
    end
  end
end
