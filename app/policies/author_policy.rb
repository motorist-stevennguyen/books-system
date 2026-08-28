class AuthorPolicy < ApplicationPolicy
  def index?
    true
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
