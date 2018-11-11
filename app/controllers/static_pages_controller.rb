class StaticPagesController < ApplicationController
  #リスト 13.40: homeアクションにマイクロポストのインスタンス変数を追加
  #リスト 13.47: homeアクションにフィードのインスタンス変数を追加
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
