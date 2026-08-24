class BookPolicy < ApplicationPolicy
  attr_reader :user, :scope
  class Scope
    def initialize(user, scope)
      raise BusinessException.new(ErrorMessages::UNAUTHORIZED_ACCESS)
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
  end

  def show?
    # is_published = record.status == StatusConst::PUBLISHED
    # true if user.role.slug == RoleConst::ADMIN
    # raise BusinessException.new(ErrorMessages::RESOURCE_NOT_AVAILABLE) unless is_published
    true
  end
end
