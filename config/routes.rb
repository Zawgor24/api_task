Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[index show create update destroy]
    end
  end

  root 'api/v1/posts#index'
end
