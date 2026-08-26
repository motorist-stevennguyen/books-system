class BookPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      raise BusinessException.new(ErrorMessages::UNAUTHORIZED_ACCESS) unless user.present?
      @user = user
      @scope = scope
    end

    def resolve
      if user.role === RoleConst::ADMIN
        scope.all
      else
        scope.where(status: StatusConst::PUBLIC)
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

  def update?
    user.role == RoleConst::ADMIN
  end

  def show?
    return true if user.role == RoleConst::ADMIN
    record.status == StatusConst::PUBLIC
  end
end
