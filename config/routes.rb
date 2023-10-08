# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'home#index'

  get "/accessibility", to: "policies#accessibility"
  get "/privacy", to: "policies#privacy"
  get "/terms", to: "policies#terms"
  get "/forgot", to: "users#forgot"

  devise_for :users,
    :controllers => {
      :registrations => "registrations",
      :sessions => "sessions",
    },
    :path => "",
    :path_names => {
      :sign_in => "login",
      :sign_out => "logout",
      :sign_up => "register",
      :password => "password",
    }

  devise_scope :user do
    get 'password', to: 'registrations#edit'
  end

  get "/delete", to: "users#delete"

  authenticated :user do
    delete "/subscriptions/:id", to: "subscriptions#destroy"
    post "/subscriptions/:id/refresh", to: "subscriptions#refresh"
    post "/notifications/:id/email", to: "notifications#email"

    get "/account", to: "users#account"
    get "/dashboard", to: "users#dashboard"

    post "/delete", to: "users#delete"

    match "/name", to: "users#name", via: [:get, :patch]
    match "/email", to: "users#email", via: [:get, :patch]
    match "/language", to: "users#language", via: [:get, :patch]
    match "/follow", to: "subscriptions#new", via: [:get, :post]

    get "/stats", to: "admin#stats"
  end
end
