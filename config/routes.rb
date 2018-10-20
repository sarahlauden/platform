Rails.application.routes.draw do
  get 'home/welcome'

  resources :industries, except: [:show]
  resources :interests, except: [:show]
  resources :majors, except: [:show]

  root to: "home#welcome"
end
