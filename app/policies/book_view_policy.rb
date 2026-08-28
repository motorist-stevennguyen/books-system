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

  def index?
    true
  end

  def growth?
    user.role == RoleConst::ADMIN
  end

  def chart?
    user.role == RoleConst::ADMIN
  end

  def destroy?
    true
  end

  def destroy_all?
    true
  end

  def show?
    true
  end
end
