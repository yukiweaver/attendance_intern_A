class MicropostsController < ApplicationController
  #リスト 13.34: Micropostsコントローラの各アクションに認可を追加
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end