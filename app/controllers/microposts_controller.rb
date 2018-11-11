class MicropostsController < ApplicationController
  #リスト 13.34: Micropostsコントローラの各アクションに認可を追加
  before_action :logged_in_user, only: [:create, :destroy]
  
  #リスト 13.36: Micropostsコントローラのcreateアクション
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      #リスト 13.50: 空の@feed_itemsインスタンス変数を追加
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end