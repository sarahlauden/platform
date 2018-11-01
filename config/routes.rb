Rails.application.routes.draw do
  devise_for :users
  
  get 'home/welcome'

  resources :industries, except: [:show]
  resources :interests, except: [:show]
  resources :locations, only: [:index, :show]
  resources :majors, except: [:show]

  resources :access_tokens, except: [:show]

  root to: "home#welcome"
end
