# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'home#index'

  devise_for :users,
    :controllers => {
      :registrations => "registrations",
    },
    :path => "",
    :path_names => {
      :sign_in => "login",
      :sign_out => "logout",
      :sign_up => "register",
    }

  authenticated :user do
    get "/dashboard", to: "dashboard#index"
    post "/subscriptions/:id/refresh", to: "subscriptions#refresh"
    post "/notifications/:id/email", to: "notifications#email"
  end

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
end
