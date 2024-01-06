class AgentPolicy
  attr_reader :user, :agent

  def initialize(user, agent)
    @user = user
    @agent = agent
  end

  def new?
    user.role == 'admin'
  end
end
