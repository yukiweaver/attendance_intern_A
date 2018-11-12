#リスト 14.32: リレーションシップのアクセス制御
#リスト 14.33: Relationshipsコントローラ
class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    #リスト 14.36: RelationshipsコントローラでAjaxリクエストに対応する
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    #リスト 14.36: RelationshipsコントローラでAjaxリクエストに対応する
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end