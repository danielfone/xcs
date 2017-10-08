Rails.application.routes.draw do
  root to: 'contacts#index'
  resources :contacts do
    collection { post :sync }
  end
end
