Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  post "/auth/register", to: "auth#register"
  post "/auth/login", to: "auth#login"

  # User CRUD routes
  resources :users, only: [ :index, :show, :update, :destroy ]

  # Weather routes
  get "/weather/current", to: "weather#current_weather"
  get "/weather/days", to: "weather#five_day_forecast"
end
