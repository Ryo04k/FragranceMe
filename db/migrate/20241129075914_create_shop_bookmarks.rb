class CreateShopBookmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :shop_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
    add_index :shop_bookmarks, [ :user_id, :shop_id ], unique: true
  end
end
