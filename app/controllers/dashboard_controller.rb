class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:profile, :score, :training]
  before_action :user_active?

  def index
    authorize :dashboard
  end

  def profile
    redirect_to new_agent_path if @user.nil?
    render locals: { user: @user }
  end

  def score
    authorize :dashboard

    agent_id = current_user.agent.id

    scores = Score.where(agent_id: agent_id)
    sales_volume = scores.sum(:sales_volume)
    lease_volume = scores.sum(:lease_volume)
    total_volume = sales_volume + lease_volume

    sales_transactions = scores.sum(:sales_transactions)
    lease_transactions = scores.sum(:lease_transactions)
    total_transactions = sales_transactions + lease_transactions

    @years = [2017, 2018, 2019, 2020, 2021, 2022, 2023]
    @months = [1,2,3,4,5,6,7,8,9,10,11,12]

    @sales_volume = sales_volume
    @lease_volume = lease_volume
    @total_volume = total_volume
    @sales_transactions = sales_transactions
    @lease_transactions = lease_transactions
    @total_transactions = total_transactions
  end

  def training
    authorize :dashboard
  end

  private

  def set_user
    @user = current_user
  end

  def user_active?
    current_user && current_user.active?
  end
end
