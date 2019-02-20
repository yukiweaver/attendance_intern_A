# 勤怠A：拠点　コントローラー
class BasePointsController < ApplicationController
  
  # 勤怠A：拠点一覧
  # 修正と追加で@baseを使い分け
  def index
    @bases = Base.all
    #binding.pry
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
    else
      flash[:danger] = "拠点情報の追加に失敗しました。"
      redirect_to base_points_path and return
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
  
  # 勤怠A：拠点情報の修正
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(params_base)
      flash[:success] = "拠点情報を修正しました。"
      redirect_to base_points_path
    else
      flash[:danger] = "拠点情報の修正に失敗しました。"
      redirect_to base_points_path and return
    end
  end
  
  private
  
  # 勤怠A：ストロングパラメーター
  def params_base
    params.require(:base).permit(:base_number, :base_name, :base_type)
  end
end
