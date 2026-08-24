class AuthorSerizlier < ActiveModel::Serializer
  include DateTimeSerializer

  attributes :name, :bio, :birth_day, :nationality
end
