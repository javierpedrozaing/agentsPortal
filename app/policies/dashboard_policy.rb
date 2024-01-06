class DashboardPolicy
  attr_reader :user

  def initialize(user, _dashboard)
    @user = user
  end

  def index?
    user.role == 'agent'
  end

  def score?
    user.role == 'agent'
  end

  def training?
    user.role == 'agent'
  end

  def profile?
    user.agent?
  end
end
