# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'home#index'

  get "/name", to: "users#name"
  get "/email", to: "users#email"
  get "/language", to: "users#language"
  patch "/users/:id", to: "users#update"

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
    }

  authenticated :user do
    get "/dashboard", to: "dashboard#index"
    delete "/subscriptions/:id", to: "subscriptions#destroy"
    post "/subscriptions/:id/refresh", to: "subscriptions#refresh"
    post "/notifications/:id/email", to: "notifications#email"
  end

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
end
