Rails.application.routes.draw do
  resources :dashboards

  resources :reflections, only: [:index]
  resources :biggest_challenges, only: [:index]
  resources :day_ratings, only: [:index]
  resources :energy_levels, only: [:index]
  resources :daily_lessons, only: [:index]
  resources :main_task, only: [:new, :create]

  devise_for :users, controllers: {
    sessions:    "users/sessions",
    passwords: "users/passwords",
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboards#index"
end
