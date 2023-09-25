# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
end
