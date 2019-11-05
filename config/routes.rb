Rails.application.routes.draw do
  resources :contents
  devise_for :users
  
  get 'home/welcome'

  resources :industries, except: [:show]
  resources :interests, except: [:show]
  resources :locations, only: [:index, :show]
  resources :majors, except: [:show]
  resources :programs, except: [:show]
  resources :roles, except: [:show]
  
  resources :people, only: [:index, :show]

  resources :postal_codes, only: [:index, :show] do
    collection do
      get :distance
      post :search
    end
  end

  resources :access_tokens, except: [:show]

  resources :validations, only: [:index] do
    collection do
      get :report
    end
  end

  root to: "home#welcome"
end
