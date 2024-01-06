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
    @years = [2017, 2018, 2019, 2020, 2021, 2022, 2023]
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
