Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :projects do
      member do
        put 'add_user_to_project'
      end
    end
    resources :users
    resources :auth, only: [] do
      collection do
        post 'login'
      end
    end
  end
end
