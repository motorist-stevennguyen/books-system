class BookViewSerializer < ActiveModel::Serializer
  include DateTimeSerializer
  include IncludeSerializer

  attributes :id
  attribute :book, if: :include_book?
  attribute :user, if: :include_user?

  def book
    BookSerializer.new(object.book)
  end

  def user
    UserSerializer.new(object.user)
  end

  def include_book?
    self.class.include_attr?(scope, :book)
  end

  def include_user?
    self.class.include_attr?(scope, :user)
  end
end
