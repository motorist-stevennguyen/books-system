class CategoryPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      rais BusinessException.new(ErrorMessages::UNAUTHORIZED_ACCESS) unless user.present?
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

  def index?
      true
  end

  def create?
    user.role == RoleConst::ADMIN
  end

  def show?
    true
  end

  def update?
    user.role == RoleConst::ADMIN
  end

  def destroy?
    user.role == RoleConst::ADMIN
  end
end
