# 拠点　コントローラー
class BasePointsController < ApplicationController
  
  # 勤怠A：拠点一覧
  def index
    @bases = Base.all
    if current_user.admin?
      @base = Base.new
    else
      flash[:warning] = "拠点一覧ページへ遷移できません。"
      redirect_to current_user
    end
  end
  
  def create
    @base = Base.new(params_base)
    if @base.save
      @bases = Base.all
      flash[:success] = "拠点登録が完了しました。"
      redirect_to "/base_points/index"
    end
  end
  
  private
  
  def params_base
    params.require(:base).permit(:base_number, :base_name, :base_type)
  end
end
