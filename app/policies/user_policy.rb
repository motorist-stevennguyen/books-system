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

  def update?
    user.role == RoleConst::ADMIN
  end

  def update_profile?
    true
  end

  def profile?
    true
  end

  def index?
    user.role == RoleConst::ADMIN
  end

  def history?
    true
  end

  def destroy?
    user.role == RoleConst::ADMIN
  end

  def show?
    true
  end

  def assets?
    user.role == RoleConst::ADMIN
  end
end
