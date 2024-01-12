# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'home#index'

  get "/accessibility", to: "policies#accessibility"
  get "/privacy", to: "policies#privacy"
  get "/terms", to: "policies#terms"
  get "/forgot", to: "users#forgot"
  get "/sitemap.xml", to: "sitemaps#show", format: "xml", as: "sitemap"

  scope module: :legal do
    get "/:document_code/:revision_code",
      to: "revisions#show",
      document_code: /\d{4}:\d+/,
      revision_code: /\d{4}:\d+/
    get "/:document_code/:revision_code/:element_code/:left_locale\::right_locale",
      to: "translations#show",
      document_code: /\d{4}:\d+/,
      revision_code: /\d{4}:\d+/,
      left_locale: /[a-z]{2}/,
      right_locale: /[a-z]{2}/
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

      resources :users

      namespace :period do
        resources :days
        resources :weeks
      end

      namespace :legal do
        resources :documents
        resources :revisions
        resources :elements
        resources :translations
      end

      namespace :period do
        resources :days
        post "/days/:id/job", to: "days#job"
        post "/weeks/:id/job", to: "weeks#job"
      end

      namespace :work_environment do
        resources :documents
        resources :notifications
        post "/documents/:id/notify", to: "documents#notify"
        post "/notifications/:id/send", to: "notifications#send_email"
      end

      get "/policies", to: "policies#index"
      match "/policies/new", to: "policies#new", via: [:get, :post]
      match "/policies/:slug", to: "policies#edit", via: [:get, :patch]

      get "/posts", to: "posts#index"
      match "/posts/new", to: "posts#new", via: [:get, :post]
      match "/posts/:slug", to: "posts#edit", via: [:get, :patch]

      get "/statistics", to: "statistics#index"
      get "/statistics/december_comparison", to: "statistics#december_comparison"
      get "/statistics/diarium", to: "statistics#diarium"
      get "/statistics/document_lag", to: "statistics#document_lag"
      get "/statistics/email_metrics", to: "statistics#email_metrics"
      get "/statistics/kitchen_sink", to: "statistics#kitchen_sink"
      get "/statistics/user_growth", to: "statistics#user_growth"
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