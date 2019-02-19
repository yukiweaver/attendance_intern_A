# 勤怠A：拠点　コントローラー
class BasePointsController < ApplicationController
  
  # 勤怠A：拠点一覧
  def index
    @bases = Base.all
    if params[:id].present?
      @base = Base.find(params[:id])
    else
      @base = Base.new
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
  
  # 勤怠A：拠点情報の削除
  def destroy
    @base = Base.find(params[:id])
    if @base.destroy
      flash[:success] = "拠点を削除しました。"
      redirect_to base_points_path
    end
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(params_base)
      flash[:success] = "拠点情報を修正しました。"
      redirect_to base_points_path
    end
  end
  
  private
  
  # 勤怠A：ストロングパラメーター
  def params_base
    params.require(:base).permit(:base_number, :base_name, :base_type)
  end
end
