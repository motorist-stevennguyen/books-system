class UserSerializer < ActiveModel::Serializer
  include DateTimeSerializer

  attributes :id, :username, :email, :full_name

  def full_name
    "#{object.first_name} #{object.last_name}"
  end
end
