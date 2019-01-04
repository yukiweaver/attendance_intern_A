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
  
  get    '/basic_info/:id',  to: "users#basic_info",  as: "basic_info"  #勤怠B：基本情報の修正ページへ遷移
  
  #リスト 14.15: Usersコントローラにfollowingアクションとfollowersアクションを追加
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]   #リスト 11.1: アカウント有効化に使うリソース (edit) を追加
  resources :password_resets,     only: [:new, :create, :edit, :update]   #リスト 12.1: パスワード再設定用リソースを追加
  resources :microposts,          only: [:create, :destroy]   #リスト 13.30: マイクロポストリソースのルーティング
  resources :relationships,       only: [:create, :destroy]   #リスト 14.20: Relationshipリソース用のルーティング
end