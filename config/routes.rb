Rails.application.routes.draw do
  resources :categories
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
  resources :libraries

  post 'agents/update_agent_status', as: 'update_agent_status'
  get 'dashboard/get_cities_by_state_and_country', as: 'get_cities_by_state_and_country'
  #get 'scores/report_pdf', to: 'scores#report_pdf', as: 'report_pdf',  format: :pdf
  match 'scores', to: 'scores#index', as: 'get_scores', via: [:get, :post]
  #post 'scores/filter', to: 'scores#filter', as: 'filter_scores'
end
