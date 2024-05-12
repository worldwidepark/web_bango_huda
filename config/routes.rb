Rails.application.routes.draw do

  scope '/admin' do
    resources :bango_hudas, only: [:index] do
      member do
        patch 'done'
        patch 'cancel'
        patch 'no_show'
        patch 'back_to_the_line'
      end
      collection do
        patch 'reset'
      end
    end
    resource :user, only: [:edit, :update, :show]
  end

  resources :users, param: :uuid do
    member do
      get 'qr_code'
    end
    resources :bango_hudas, except: [:index],:param => :uuid
  end

  root 'static_pages#before_login'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post '/google_login_api/callback', to: 'google_login_api#callback'
  delete 'logout', to: 'google_login_api#logout', as: :logout

  # Defines the root path route ("/")
  # root "posts#index"
end
