class CreateShopImages < ActiveRecord::Migration[7.2]
  def change
    create_table :shop_images do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
