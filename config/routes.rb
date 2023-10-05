# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'home#index'


  get "/accessibility", to: "policies#accessibility"
  get "/privacy", to: "policies#privacy"
  get "/terms", to: "policies#terms"

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

  authenticated :user do
    delete "/subscriptions/:id", to: "subscriptions#destroy"
    post "/subscriptions/:id/refresh", to: "subscriptions#refresh"
    post "/notifications/:id/email", to: "notifications#email"

    get "/account", to: "users#account"
    get "/dashboard", to: "users#dashboard"
    get "/name", to: "users#name"
    get "/email", to: "users#email"
    get "/language", to: "users#language"

    patch "/users/:id", to: "users#update"

    get "/follow", to: "subscriptions#new"
    post "/follow", to: "subscriptions#create"
  end

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
end
