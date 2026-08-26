class AuthorSerializer < ActiveModel::Serializer
  attributes :name, :bio, :birth_date, :nationality
end
