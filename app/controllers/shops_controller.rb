class ShopsController < ApplicationController
  before_action :set_ransack_query, only: [ :search ]

  def search
    if params[:q].blank?
      @shops = [] # 検索条件がない場合は空の配列に設定
    else
      @q = Shop.ransack(params[:q])
      @shops = @q.result(distinct: true) # 検索条件がある場合のみ検索結果を設定
    end
  end


  private

  def set_ransack_query
    @q = Shop.ransack(params[:q])
  end
end
