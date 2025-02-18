require 'rails_helper'

RSpec.describe ShopBookmark, type: :model do
  describe "バリデーションのテスト" do
    it "ユーザーとショップが存在する場合、ブックマークが有効であること" do
      user = create(:user)
      shop = create(:shop)
      bookmark = ShopBookmark.new(user: user, shop: shop)
      expect(bookmark).to be_valid
    end

    it "ユーザーが存在しない場合、ブックマークが無効であること" do
      shop = create(:shop)
      bookmark = ShopBookmark.new(shop: shop)
      bookmark.valid?
      expect(bookmark.errors[:user]).not_to be_empty
    end

    it "ショップが存在しない場合、ブックマークが無効であること" do
      user = create(:user)
      bookmark = ShopBookmark.new(user: user)
      bookmark.valid?
      expect(bookmark.errors[:shop]).not_to be_empty
    end

    describe "アソシエーションのテスト" do
      it "ブックマークはユーザーに属していること" do
        user = create(:user)
        shop = create(:shop)
        bookmark = create(:shop_bookmark, user: user, shop: shop)
        expect(bookmark.user).to eq(user)
      end

      it "ユーザーはブックマークに属していること" do
        user = create(:user)
        shop = create(:shop)
        bookmark = user.bookmark(shop)
        expect(user.shop_bookmarks).to include(bookmark)
      end
    end
  end
end
