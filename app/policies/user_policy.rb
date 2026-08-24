class UserPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
    end
  end

  def history?
    true
  end

  def show?
    true
  end
end
