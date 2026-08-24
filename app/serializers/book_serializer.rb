class BookSerializer < ActiveModel::Serializer
  include DateTimeSerializer
  include IncludeSerializer

  attributes :id, :code, :thumbnail, :language, :title
  attribute :author, if: :include_author?
  attribute :categories, if: :include_categories?

  def categories
    scope[:categories] ||= []
  end

  def thumbnail
    object.cover_url
  end

  def include_categories?
    scope.present? && scope[:categories]
  end

  def include_author?
    self.class.include_attr?(scope, :author)
  end
end
