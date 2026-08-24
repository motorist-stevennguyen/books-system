class UserSerializer < ActiveModel::Serializer
  include DateTimeSerializer

  attributes :id, :username, :email
end
