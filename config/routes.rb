Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]   #リスト 11.1: アカウント有効化に使うリソース (edit) を追加
  resources :password_resets,     only: [:new, :create, :edit, :update]   #リスト 12.1: パスワード再設定用リソースを追加
end