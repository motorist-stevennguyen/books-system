class AuthorPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.role == RoleConst::ADMIN
        scope.all
      else
        scope.all
      end
    end

    private
    attr_reader :user, :scope
  end
  def create?
    user.role == RoleConst::ADMIN
  end

  def show?
    user.role == RoleConst::ADMIN
  end

  def update?
    user.role == RoleConst::ADMIN
  end

  def destroy?
    user.role == RoleConst::ADMIN
  end
end
