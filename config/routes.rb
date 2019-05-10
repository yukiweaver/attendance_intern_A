Rails.application.routes.draw do

  # get    'base_points/index'
  # post   'base_points/create'
  # post   '/base_points/:id/destroy',  to: "base_points#destroy",  as: "base_points_destroy"

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get    '/basic_info/:id',  to: "users#basic_info",  as: "basic_info"   #勤怠B：基本情報の修正ページへ遷移
  post   '/basic_info_update/:id', to: 'users#basic_info_update', as: 'basic_info_update'  #勤怠B：基本情報の更新
  post   '/beginning_time/:id', to: 'users#beginning_time', as: 'beginning_time'  #勤怠B：出社ボタン押し込み
  post   '/leaving_time/:id', to: 'users#leaving_time', as: 'leaving_time'  #勤怠B：退社ボタン押し込み
  get    '/attendance_edit/:id', to: 'attendances#attendance_edit', as: 'attendance_edit'  #勤怠B：勤怠編集画面へ遷移
  post   '/attendance_update/:id', to: 'attendances#attendance_update', as: 'attendance_update'  #勤怠B：勤怠編集の更新
  get    '/attendance_index', to: 'attendances#attendance_index', as: 'attendance_index'  #勤怠A：出勤社員一覧へ遷移
  post   '/attendance_overtime_update/:id', to: 'attendances#overtime_update', as: 'attendance_overtime_update'  #勤怠A：1日分の残業申請
  post   '/attendance_month_update/:id', to: 'attendances#month_update', as: 'attendance_month_update'  # 勤怠A：一月分の勤怠申請
  post   '/attendance_overtime_authorizer_update/:id', to: 'attendances#authorizer_overtime_update', as: 'authorizer_overtime_update'  # 一日分の残業承認
  post   '/attendance_authorizer_update/:id', to: 'attendances#authorizer_attendance_update', as: 'authorizer_attendance_update'  # 勤怠変更承認
  post   '/month_attendance_authorizer_update/:id', to: 'attendances#month_attendance_authorizer_update', as: 'month_attendance_authorizer_update' # 月の勤怠承認
  get    '/approval_histories/index', to: 'attendances#approval_histories', as: 'approval_histories'  # 勤怠ログ遷移
  
  # csv読み込みのため、routes追加
  resources :users do
    collection {post :import}
  end
  resources :base_points
  #get    '//top',    to: 'static_pages#top',  as: "top"  # 勤怠B：ログイン有でのトップページの遷移先（管理者ログインのヘッダーに伴う）
end