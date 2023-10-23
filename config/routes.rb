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
  match "/unsubscribe/:id", to: "subscriptions#unsubscribe", via: [:get, :post]
  get "/delete", to: "users#delete"
  get "/download", to: "users#download"

  get "/:year/:month/:day/:slug",
    to: "posts#show", 
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
    post "/download", to: "users#download"
    post "/follow", to: "subscriptions#new"

    match "/name", to: "users#name", via: [:get, :patch]
    match "/email", to: "users#email", via: [:get, :patch]
    match "/language", to: "users#language", via: [:get, :patch]
    match "/follow", to: "subscriptions#new", via: [:get, :post]

    get "/admin", to: "admin#index"
    get "/admin/days", to: "admin#days"
    get "/admin/policies", to: "admin#policies"
    match "/admin/policies/new", to: "admin#new_policy", via: [:get, :post]
    match "/admin/policies/:slug", to: "admin#edit_policy", via: [:get, :patch]
    get "/admin/posts", to: "admin#posts"
    match "/admin/posts/new", to: "admin#new_post", via: [:get, :post]
    match "/admin/posts/:slug", to: "admin#edit_post", via: [:get, :patch]
    get "/stats", to: "admin#stats"

    get "/admin/:date",
      to: "admin#day", 
      :date => /(19|20)\d{2}-([1-9]|1[0-2])-(0[0-9]|1[0-9]|2[0-9]|3[0-1])/
    post "/admin/:date/job",
      to: "admin#day_job", 
      :date => /(19|20)\d{2}-([1-9]|1[0-2])-(0[0-9]|1[0-9]|2[0-9]|3[0-1])/
  end
end
