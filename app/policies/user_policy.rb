class UserPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, _agent)
    @user = user
  end

  def index?
    user.role == 'admin'
  end

  def edit?
    user.active?
  end

  def new?
    user.role == 'admin'
  end
end
