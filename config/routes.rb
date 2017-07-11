Rails.application.routes.draw do
  resources :posts do
    collection do
      post :preview_md_content
    end
  end
  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks"
             }
  namespace :api do
    resources :posts,
              only: [:index, :show, :update]
  end
  namespace :admin do
    resources :posts, only: [] do
      member do
        post :toggle_highlight
      end
    end
  end
  resource :post_visit, path: 'v', only: [] do
    get ':user_id/:post_id', action: :show, as: :consume
  end
  get "/howto", to: 'home#howto', as: :howto
  root "home#welcome"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
