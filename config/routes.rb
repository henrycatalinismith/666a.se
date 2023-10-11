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

  get "/follow", to: "subscriptions#new"
  get "/delete", to: "users#delete"

  get "/:year/:month/:day/:slug",
    to: "news#show", 
    :year => /(19|20)\d{2}/,
    :month => /([1-9]|1[0-2])/,
    :day => /(0[0-9]|1[0-9]|2[0-9]|3[0-1])/,
    :slug => /[a-z0-9-]+/

  authenticated :user do
    delete "/subscriptions/:id", to: "subscriptions#destroy"
    post "/subscriptions/:id/refresh", to: "subscriptions#refresh"
    post "/notifications/:id/email", to: "notifications#email"

    get "/account", to: "users#account"
    get "/dashboard", to: "users#dashboard"

    post "/delete", to: "users#delete"
    post "/follow", to: "subscriptions#new"

    match "/name", to: "users#name", via: [:get, :patch]
    match "/email", to: "users#email", via: [:get, :patch]
    match "/language", to: "users#language", via: [:get, :patch]
    match "/follow", to: "subscriptions#new", via: [:get, :post]

    get "/stats", to: "admin#stats"
  end
end
