class AgentsController < ApplicationController
  before_action :set_user, only: [:new, :create, :edit, :update]

  def index
    @users = User.where(role: 'agent')
    .joins("LEFT JOIN agents ON users.id = agents.user_id")
  end

  def new
    @agent = @user.build_agent
    authorize @agent
  end

  def update
    user = User.find(params[:id])
    if user.agent.update(agent_params) && user.update(user_params)
      redirect_to profile_path, notice: 'Agent was successfully updated.'
    else
      redirect_to @agent, notice: 'Agent was not successfully updated.'
    end
  end

  def update_agent_status
    user = User.find(params[:user_id])
    user.active = params[:active]

    if user.save
      redirect_to agents_path, notice: 'Agent was successfully updated.'
    else
      redirect_to agents_path, notice: 'Agent was not successfully updated.'
    end
  end

  def show

  end

  def create
    @user = User.new(user_params)
    @agent = @user.build_agent(agent_params)

    if @user.save && @agent.save
      redirect_to @agent, notice: 'Agent was successfully created.'
    else
      render :new
    end
  end

  private

  def set_user
    # Fetch the user from your database, for example, based on a specific condition
    @user = User.new
  end

  def user_params
    params.permit(:name, :last_name, :email, :role, :password, :password_confirmation)
  end

  def agent_params
    params.permit(:phone, :address_home, :city, :state, :zip_code, :licence, :split)
  end
end
