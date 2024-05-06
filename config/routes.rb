# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root "home#index"
  get "/work-environment", to: "users#dashboard"
  get "/dashboard", to: redirect("/work-environment")
  Dir
    .glob(Rails.root.join("app", "pages", "*.en.md"))
    .each { |file| get "/#{File.basename(file, ".en.md")}", to: "pages#show" }

  get "/news",
      to: redirect("/going-open-source"),
      permanent: false

  get "/2024/01/22/night-work-tech-and-swedish-labour-law",
      to: redirect("/night-work-tech-and-swedish-labour-law")
  get "/2023/12/03/incident-report", to: redirect("/incident-report")
  get "/2023/11/14/english-translations-of-swedish-laws",
      to: redirect("/english-translations-of-swedish-laws")
  get "/2023/10/31/launch-announcement", to: redirect("/launch-announcement")

  get "/1977:1160/2014:659", to: redirect("/labour-law/work-environment-act/2014:659")
  get "/1976:580/2021:1114", to: redirect("/labour-law/codetermination-act/2021:1114")
  get "/1982:80/2022:836", to: redirect("/labour-law/employment-protection-act/2022:836")
  get "/1982:673/2013:611", to: redirect("/labour-law/working-hours-act/2013:611")
  get "/aml-v2014:659-in-english", to: redirect("/labour-law/work-environment-act/2014:659")
  get "/mbl-v2021:1114-in-english", to: redirect("/labour-law/codetermination-act/2021:1114")
  get "/las-v2022:836-in-english", to: redirect("/labour-law/employment-protection-act/2022:836")
  get "/atl-v2013:611-in-english", to: redirect("/labour-law/working-hours-act/2013:611")

  get "/labour-law/:document_slug/:revision_code", to: "labour_law/revisions#show", as: "labour_law_revision"

  get "/section-:element_section-of-:document_code-v:revision_code-in-english", to: "labour_law/translations#show"
  get "/chapter-:element_chapter-section-:element_section-of-:document_code-v:revision_code-in-english", to: "labour_law/translations#show"

  get "/labour-law", to: "labour_law/documents#index"
  get "/swedish-labour-laws-in-english", to: redirect("/labour-law")
  get "/:document_code-v:revision_code-in-english", to: "labour_law/revisions#show"

  get "/1977:1160/2014:659/:element_code/sv:en",
      to:
        redirect { |params|
          "/chapter-#{params[:element_code].match(/K(\d)/)[1]}-section-#{params[:element_code].match(/P(\d[a-z]?)/)[1]}-of-aml-v2014:659-in-english"
        },
      chapter: /\d/

  get "/1976:580/2021:1114/P:section/sv:en",
      to:
        redirect { |params|
          "/section-#{params[:section]}-of-mbl-v2021:1114-in-english"
        }

  get "/1982:80/2022:836/P:section/sv:en",
      to:
        redirect { |params|
          "/section-#{params[:section]}-of-las-v2022:836-in-english"
        }

  get "/1982:673/2013:611/P:section/sv:en",
      to:
        redirect { |params|
          "/section-#{params[:section]}-of-atl-v2013:611-in-english"
        }

  get "/forgot", to: "users#forgot"
  get "/sitemap.xml", to: "sitemaps#show", format: "xml", as: "sitemap"
  get "/feed.xml", to: "pages#index"

  devise_for :users,
             class_name: "User::Account",
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

      namespace :labour_law do
        resources :documents
        resources :revisions
        resources :elements
        resources :translations

        post "/revisions/:id/copy", to: "revisions#copy"
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

    post "/delete", to: "users#delete"
    post "/download", to: "users#download"

    match "/name", to: "users#name", via: %i[get patch]
    match "/email", to: "users#email", via: %i[get patch]
    match "/language", to: "users#language", via: %i[get patch]
  end

  mount Lookbook::Engine, at: "/components"

  scope module: :work_environment do
    get "/diarium", to: "documents#index"
  end

  constraints CanAccessFlipperUI do
    mount Flipper::UI.app(Flipper) => "/flipper"
  end
end
