class AuthorSerializer < ActiveModel::Serializer
  include DateTimeSerializer

  attributes :name, :bio, :birth_date, :nationality
end
