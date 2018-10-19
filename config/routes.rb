Rails.application.routes.draw do
  get 'home/welcome'

  resources :industries, except: [:show]

  root to: "home#welcome"
end
