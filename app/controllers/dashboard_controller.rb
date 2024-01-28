class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:profile, :score, :training]
  before_action :user_active?

  def index
    authorize :dashboard
  end

  def profile
    redirect_to new_agent_path if @user.nil?
    states, cities = get_countries_states_and_cities
    render locals: { user: @user, states: states, cities: cities }
  end

  def score
    authorize :dashboard

    user_id = current_user.id

    scores = Score.where(user_id: user_id)
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

  def get_cities_by_state_and_country
    state = params[:state]
    country = params[:country] || 'US'
    cities = ApplicationHelper::cities_list_by_state_and_country(state, country)
    render json: cities
  end

  private

  def get_countries_states_and_cities
    states_list = ApplicationHelper::states_list_by_country('US')
    @states = states_list.nil? || states_list.length <= 1 ? [] : states_list.map{|c| [c['name'], c['iso2']]}
    cities_list = ApplicationHelper::cities_list('US')
    @cities = cities_list.nil? || states_list.length <= 1 ? [] : cities_list.map{|c| [c['name'], c['id']]}
    [@states.uniq.compact, @cities.uniq.compact]
  end

  def set_user
    @user = current_user
  end

  def user_active?
    current_user && current_user.active?
  end
end
