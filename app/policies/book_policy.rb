class BookPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      raise BusinessException.new(ErrorMessages::UNAUTHORIZED_ACCESS) unless user.present?
      @user = user
      @scope = scope
    end

    def resolve
      if user.role.slug === RoleConst::ADMIN
        scope.all
      else
        scope.where(status: StatusConst::PUBLISHED)
      end
    end

    private
    attr_reader :user, :scope
  end

  def index?
    true
  end

  def create?
    user.role.slug == RoleConst::ADMIN
  end

  def update?
    user.role.slug == RoleConst::ADMIN
  end

  def show?
    return true if user.role.slug == RoleConst::ADMIN
    record.status == StatusConst::PUBLISHED
  end
end
