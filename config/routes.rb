Rails.application.routes.draw do
  root to: 'contacts#index'
  resources :contacts do
    collection { post :perform }
  end
end
