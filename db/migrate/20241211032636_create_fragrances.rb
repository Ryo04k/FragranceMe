class CreateFragrances < ActiveRecord::Migration[7.2]
  def change
    create_table :fragrances do |t|
      t.string :name, null: false
      t.string :image_url

      t.timestamps
    end
  end
end
