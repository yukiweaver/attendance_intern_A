Rails.application.routes.draw do
  get 'attendances/edit'

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
  #get    '/users/index',  to: 'users#index',  as: "users"  # 勤怠B：ユーザー一覧（管理者ログイン時のヘッダーに伴う）
  
  get    '/basic_info/:id',  to: "users#basic_info",  as: "basic_info"  #勤怠B：基本情報の修正ページへ遷移
  post   '/basic_info_update/:id', to: 'users#basic_info_update', as: 'basic_info_update'  #勤怠B：基本情報の更新
  post   '/beginning_time/:id', to: 'users#beginning_time', as: 'beginning_time'  #勤怠B：出社ボタン押し込み
  post   '/leaving_time/:id', to: 'users#leaving_time', as: 'leaving_time'  #勤怠B：退社ボタン押し込み
  get    '/attendance_edit/:id', to: 'attendances#attendance_edit', as: 'attendance_edit'  #勤怠B：勤怠編集画面へ遷移
  post   '/attendance_update/:id', to: 'attendances#attendance_update', as: 'attendance_update'  #勤怠B：勤怠編集の更新
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
  
  #get    '//top',    to: 'static_pages#top',  as: "top"  # 勤怠B：ログイン有でのトップページの遷移先（管理者ログインのヘッダーに伴う）
end