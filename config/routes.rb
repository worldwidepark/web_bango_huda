Rails.application.routes.draw do
  scope '/admin' do
    resources :bango_hudas, only: [:index] do
      member do
        patch 'done'
        patch 'cancel'
        patch 'no_show'
      end
      collection do
        patch 'reset'
      end
    end
    resources :users, only:[:edit, :show, :update]
  end

  resources :users, param: :uuid do
    resources :bango_hudas, except: :index
  end

  get 'google_login_api/callback'
  get 'static_pages/before_login'
  get 'static_pages/after_login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'static_pages#before_login'
  get '/after_login', to: 'static_pages#after_login'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post '/google_login_api/callback', to: 'google_login_api#callback'


  # Defines the root path route ("/")
  # root "posts#index"
end
