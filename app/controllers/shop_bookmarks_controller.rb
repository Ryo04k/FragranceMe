class ShopBookmarksController < ApplicationController
  def create
    @shop = Shop.find(params[:shop_id])
    current_user.bookmark(@shop)
    flash.now[:success] = "お気に入りに追加しました"
  end

  def destroy
    @shop = current_user.shop_bookmarks.find(params[:id]).shop
    current_user.unbookmark(@shop)
    flash.now[:success] = "お気に入りから削除しました"
  end
end
