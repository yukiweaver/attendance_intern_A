Rails.application.routes.draw do

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get    '/basic_info/:id',  to: "users#basic_info",  as: "basic_info"  #勤怠B：基本情報の修正ページへ遷移
  post   '/basic_info_update/:id', to: 'users#basic_info_update', as: 'basic_info_update'  #勤怠B：基本情報の更新
  post   '/beginning_time/:id', to: 'users#beginning_time', as: 'beginning_time'  #勤怠B：出社ボタン押し込み
  post   '/leaving_time/:id', to: 'users#leaving_time', as: 'leaving_time'  #勤怠B：退社ボタン押し込み
  get    '/attendance_edit/:id', to: 'attendances#attendance_edit', as: 'attendance_edit'  #勤怠B：勤怠編集画面へ遷移
  post   '/attendance_update/:id', to: 'attendances#attendance_update', as: 'attendance_update'  #勤怠B：勤怠編集の更新
  
  resources :users
  #get    '//top',    to: 'static_pages#top',  as: "top"  # 勤怠B：ログイン有でのトップページの遷移先（管理者ログインのヘッダーに伴う）
end