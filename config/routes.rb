Rails.application.routes.draw do
  resources :transactions do
    collection do
      post 'import'
    end
  end
  get 'dashboard/index', as: 'dashboard'
  get 'dashboard/profile', as: 'profile'
  match 'dashboard/score', to: 'dashboard#score', as: 'score', via: [:get, :post]
  get 'dashboard/training', as: 'training'

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  devise_for :users
  resources :users
  resources :agents

  post 'agents/update_agent_status', as: 'update_agent_status'
  get 'dashboard/get_cities_by_state_and_country', as: 'get_cities_by_state_and_country'
  get 'scores/generate_report', to: 'scores#generate_report', as: 'generate_report'
  get 'scores', to: 'scores#index', as: 'get_scores'
  get 'report', to: 'scores#report'
end
