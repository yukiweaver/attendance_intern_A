class MicropostsController < ApplicationController
  #リスト 13.34: Micropostsコントローラの各アクションに認可を追加
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy   #リスト 13.52
  
  #リスト 13.36: Micropostsコントローラのcreateアクション
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿しました。"
      redirect_to root_url
    else
      #リスト 13.50: 空の@feed_itemsインスタンス変数を追加
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  #リスト 13.52: Micropostsコントローラのdestroyアクション
  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)   #リスト 13.61: pictureを許可された属性のリストに追加
    end
    
    #リスト 13.52
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end