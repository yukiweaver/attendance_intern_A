# 勤怠A：拠点　コントローラー
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
  
  # 勤怠A：拠点情報の新規追加
  def create
    @base = Base.new(params_base)
    if @base.save
      flash[:success] = "拠点登録が完了しました。"
      redirect_to base_points_path
      #render "index"
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    if @base.destroy
      flash[:success] = "拠点を削除しました。"
      redirect_to base_points_path
    end
  end
  
  private
  
  # 勤怠A：ストロングパラメーター
  def params_base
    params.require(:base).permit(:base_number, :base_name, :base_type)
  end
end
