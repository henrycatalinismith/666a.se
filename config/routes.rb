# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'home#index'

  get "/accessibility", to: "policies#accessibility"
  get "/privacy", to: "policies#privacy"
  get "/terms", to: "policies#terms"
  get "/forgot", to: "users#forgot"

  scope module: :legal do
    get "/:document_code/:revision_code",
      to: "revisions#show",
      document_code: /\d{4}:\d{4}/,
      revision_code: /\d{4}:\d+/
    get "/:document_code/:revision_code/:element_code/:locale",
      to: "translations#show",
      document_code: /\d{4}:\d{4}/,
      revision_code: /\d{4}:\d+/
  end

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
  get "/download", to: "users#download"

  get "/:year/:month/:day/:slug",
    to: "posts#show", 
    :year => /(19|20)\d{2}/,
    :month => /([1-9]|1[0-2])/,
    :day => /(0[0-9]|1[0-9]|2[0-9]|3[0-1])/,
    :slug => /[a-z0-9-]+/

  scope module: :work_environment do
    get "/follow", to: "subscriptions#new"
    match "/unsubscribe/:id", to: "subscriptions#unsubscribe", via: [:get, :post]
    authenticated :user do
      delete "/subscriptions/:id", to: "subscriptions#destroy"
      post "/follow", to: "subscriptions#new"
    end
  end

  namespace :admin do
    authenticated :user do
      get "/", to: "dashboard#index"
      get "/days", to: "days#index"
      get "/days/:date", to: "days#show", :date => /(19|20)\d{2}-(\d{2})-(0[0-9]|1[0-9]|2[0-9]|3[0-1])/
      post "/days/:date/job",
        to: "days#job", 
        :date => /(19|20)\d{2}-(\d{2})-(0[0-9]|1[0-9]|2[0-9]|3[0-1])/

      namespace :legal do
        resources :documents
        resources :revisions
        resources :elements
        resources :translations
      end

      get "/policies", to: "policies#index"
      match "/policies/new", to: "policies#new", via: [:get, :post]
      match "/policies/:slug", to: "policies#edit", via: [:get, :patch]

      get "/posts", to: "posts#index"
      match "/posts/new", to: "posts#new", via: [:get, :post]
      match "/posts/:slug", to: "posts#edit", via: [:get, :patch]

      get "/stats", to: "stats#index"
    end
  end

  authenticated :user do
    get "/account", to: "users#account"
    get "/dashboard", to: "users#dashboard"

    post "/delete", to: "users#delete"
    post "/download", to: "users#download"

    match "/name", to: "users#name", via: [:get, :patch]
    match "/email", to: "users#email", via: [:get, :patch]
    match "/language", to: "users#language", via: [:get, :patch]

  end
end