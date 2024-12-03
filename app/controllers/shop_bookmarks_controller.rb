class ShopBookmarksController < ApplicationController

  def create
    @shop = Shop.find(params[:shop_id]) # リクエストからshop_idを取得し、そのidに基づいたショップをデータベースから検索
    current_user.bookmark(@shop) # 取得したショップをブックマークに追加するメソッドを呼び出し、ユーザーのブックマークリストにショップを追加
    flash.now[:success] = "お気に入りに追加しました"
  end

  def destroy
    @shop = current_user.shop_bookmarks.find(params[:id]).shop
    current_user.unbookmark(@shop)
    flash.now[:success] = "お気に入りから削除しました"
  end
end
