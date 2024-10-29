class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.string :name, null: false # 店名
      t.string :postal_code        # 郵便番号
      t.string :address            # 住所
      t.string :phone_number       # 電話番号
      t.string :opening_hours      # 営業時間
      t.string :web_site            # 公式サイト
      t.decimal :rating            # Googleレビュー
      t.decimal :latitude, precision: 10, scale: 7, null: false # 緯度
      t.decimal :longitude, precision: 10, scale: 7, null: false # 経度
      t.string :place_id, null: false # Google Places ID
      t.boolean :has_experience, default: false, null: false # ワークショップの有無
      t.integer :prefecture, null: false # 都道府県ID

      t.timestamps
    end
  end
end
