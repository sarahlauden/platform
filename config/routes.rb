Rails.application.routes.draw do
  get 'home/welcome'

  resources :industries

  root to: "home#welcome"
end
