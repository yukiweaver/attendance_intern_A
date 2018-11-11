class StaticPagesController < ApplicationController
  #リスト 13.40: homeアクションにマイクロポストのインスタンス変数を追加
  def home
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
