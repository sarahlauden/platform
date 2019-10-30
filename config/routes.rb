Rails.application.routes.draw do
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


  # RubyCAS Routes
  resources :cas, except: [:show]
  get '/login', to: 'cas#login'
  post '/login', to: 'cas#loginpost'
  get '/logout', to: 'cas#logout'
  get '/loginTicket', to: 'cas#loginTicket'
  post '/loginTicket', to: 'cas#loginTicketPost'
  get '/validate', to: 'cas#validate'
  get '/serviceValidate', to: 'cas#serviceValidate'
  get '/proxyValidate', to: 'cas#proxyValidate'
  get '/proxy', to: 'cas#proxy'

end
