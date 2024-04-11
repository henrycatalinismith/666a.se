# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root "home#index"

  get "/accessibility", to: "pages#show"
  get "/privacy", to: "pages#show"
  get "/terms", to: "pages#show"
  get "/forgot", to: "users#forgot"
  get "/sitemap.xml", to: "sitemaps#show", format: "xml", as: "sitemap"
  get "/feed.xml", to: "posts#index"

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
             controllers: {
               registrations: "registrations",
               sessions: "sessions"
             },
             path: "",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
               sign_up: "register",
               password: "password"
             }

  devise_scope :user do
    get "password", to: "registrations#edit"
  end

  get "/delete", to: "users#delete"
  get "/download", to: "users#download"

  get "/:year/:month/:day/:slug",
      to: "posts#show",
      year: /(19|20)\d{2}/,
      month: /(0[0-9]|1[0-2])/,
      day: /(0[0-9]|1[0-9]|2[0-9]|3[0-1])/,
      slug: /[a-z0-9-]+/

  scope module: :work_environment do
    get "/follow", to: "subscriptions#new"
    match "/unsubscribe/:id", to: "subscriptions#unsubscribe", via: %i[get post]
    authenticated :user do
      delete "/subscriptions/:id", to: "subscriptions#destroy"
      post "/follow", to: "subscriptions#new"
    end
  end

  namespace :admin do
    authenticated :user do
      get "/", to: "dashboard#index"

      resources :users

      namespace :time_period do
        resources :days
        resources :weeks
        post "/days/:id/job", to: "days#job"
        post "/weeks/:id/job", to: "weeks#job"
      end

      namespace :legal do
        resources :documents
        resources :revisions
        resources :elements
        resources :translations
      end

      namespace :work_environment do
        resources :documents
        resources :notifications
        post "/documents/:id/notify", to: "documents#notify"
        post "/notifications/:id/send", to: "notifications#send_email"
      end

      get "/policies", to: "policies#index"
      match "/policies/new", to: "policies#new", via: %i[get post]
      match "/policies/:slug", to: "policies#edit", via: %i[get patch]

      get "/posts", to: "posts#index"
      match "/posts/new", to: "posts#new", via: %i[get post]
      match "/posts/:slug", to: "posts#edit", via: %i[get patch]

      get "/statistics", to: "statistics#index"
      get "/statistics/december_comparison",
          to: "statistics#december_comparison"
      get "/statistics/diarium", to: "statistics#diarium"
      get "/statistics/requests", to: "statistics#requests"
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

    match "/name", to: "users#name", via: %i[get patch]
    match "/email", to: "users#email", via: %i[get patch]
    match "/language", to: "users#language", via: %i[get patch]
  end
end
