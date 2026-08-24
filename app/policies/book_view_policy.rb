class BookViewPolicy < ApplicationPolicy
  attr_reader :user, :scope
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
    end
  end

  def show?
    true
  end
end
