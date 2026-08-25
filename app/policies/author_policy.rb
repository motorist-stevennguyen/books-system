class AuthorPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.role.slug == RoleConst::ADMIN
        scope.all
      else
        scope.all
      end
    end

    private
    attr_reader :user, :scope
  end
  def create?
    user.role.slug == RoleConst::ADMIN
  end

  def show?
    user.role.slug == RoleConst::ADMIN
  end

  def update?
    user.role.slug == RoleConst::ADMIN
  end

  def update?
    user.role.slug == RoleConst::ADMIN
  end

  def destroy?
    user.role.slug == RoleConst::ADMIN
  end
end
