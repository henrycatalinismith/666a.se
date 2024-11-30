# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  root "home#index"
  get "/work-environment", to: "users#dashboard"
  get "/dashboard", to: redirect("/work-environment")

  get "/news",
    to: redirect("/news/accidentally-sending-too-many-http-requests"),
    permanent: false

  get "/news/:slug", to: "news#show", as: "news_post"
  get "/about", to: "pages#show", as: "about_index"
  get "/about/:slug", to: "pages#show", as: "about_page"

  get "/accessibility", to: redirect("/about/accessibility")
  get "/architecture", to: redirect("/about/architecture")
  get "/conduct", to: redirect("/about/conduct")
  get "/contributing", to: redirect("/about/contributing")
  get "/development", to: redirect("/about/development")
  get "/labour-law-module", to: redirect("/about/labour-law-module")
  get "/license", to: redirect("/about/license")
  get "/operations", to: redirect("/about/operations")
  get "/privacy", to: redirect("/about/privacy")
  get "/security", to: redirect("/about/security")
  get "/split-email-alerting-into-multiple-jobs", to: redirect("/about/split-email-alerting-into-multiple-jobs")
  get "/terms", to: redirect("/about/terms")
  get "/time-period-module", to: redirect("/about/time-period-module")
  get "/use-rails", to: redirect("/about/use-rails")
  get "/use-rufus-scheduler", to: redirect("/about/use-rufus-scheduler")
  get "/use-sqlite", to: redirect("/about/use-sqlite")
  get "/user-module", to: redirect("/about/user-module")
  get "/work-environment-module", to: redirect("/about/work-environment-module")

  get "/2024/01/22/night-work-tech-and-swedish-labour-law", to: redirect("/news/night-work-tech-and-swedish-labour-law")
  get "/2023/12/03/incident-report", to: redirect("/news/incident-report")
  get "/2023/11/14/english-translations-of-swedish-laws", to: redirect("/news/english-translations-of-swedish-laws")
  get "/2023/10/31/launch-announcement", to: redirect("/news/launch-announcement")
  get "/night-work-tech-and-swedish-labour-law", to: redirect("/news/night-work-tech-and-swedish-labour-law")
  get "/incident-report", to: redirect("/news/incident-report")
  get "/english-translations-of-swedish-laws", to: redirect("/news/english-translations-of-swedish-laws")
  get "/launch-announcement", to: redirect("/news/launch-announcement")

  get "/1977:1160/2014:659", to: redirect("/labour-law/work-environment-act/2023:349")
  get "/1976:580/2021:1114", to: redirect("/labour-law/codetermination-act/2021:1114")
  get "/1982:80/2022:836", to: redirect("/labour-law/employment-protection-act/2022:836")
  get "/1982:673/2013:611", to: redirect("/labour-law/working-hours-act/2013:611")
  get "/aml-v2014:659-in-english", to: redirect("/labour-law/work-environment-act/2023:349")
  get "/mbl-v2021:1114-in-english", to: redirect("/labour-law/codetermination-act/2021:1114")
  get "/las-v2022:836-in-english", to: redirect("/labour-law/employment-protection-act/2022:836")
  get "/atl-v2013:611-in-english", to: redirect("/labour-law/working-hours-act/2013:611")

  get "/labour-law/:document_slug/:revision_code",
    to: "labour_law/revisions#show",
    as: "labour_law_revision"
  get "/labour-law/:document_slug/:revision_code/:element_slug",
    to: "labour_law/elements#show",
    as: "labour_law_element"

  get "/chapter-:c-section-:s-of-aml-v2014:659-in-english",
    to: redirect { |params|
      "/labour-law/work-environment-act/2023:349/chapter-#{params[:c]}-section-#{params[:s]}"
    }

  get "/section-:s-of-mbl-v2021:1114-in-english",
    to: redirect { |params|
      "/labour-law/codetermination-act/2021:1114/section-#{params[:s]}"
    }

  get "/section-:s-of-las-v2022:836-in-english",
    to: redirect { |params|
      "/labour-law/employment-protection-act/2022:836/section-#{params[:s]}"
    }

  get "/section-:s-of-atl-v2013:611-in-english",
    to: redirect { |params|
      "/labour-law/working-hours-act/2013:611/section-#{params[:s]}"
    }

  get "/labour-law", to: "labour_law/documents#index"
  get "/swedish-labour-laws-in-english", to: redirect("/labour-law")

  get "/1977:1160/2014:659/:element_code/sv:en",
      to:
        redirect { |params|
          "/chapter-#{params[:element_code].match(/K(\d)/)[1]}-section-#{params[:element_code].match(/P(\d[a-z]?)/)[1]}-of-aml-v2023:349-in-english"
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

  namespace :glossary do
    get "/", to: "words#index"
    get "/:word_slug", to: "words#show"
  end
end
