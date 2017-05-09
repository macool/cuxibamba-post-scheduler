Rails.application.routes.draw do
  resources :posts
  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks"
             }
  namespace :api do
    resources :posts,
              only: [:index]
  end
  root "home#welcome"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
