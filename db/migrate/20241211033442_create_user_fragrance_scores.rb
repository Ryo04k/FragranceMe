class CreateUserFragranceScores < ActiveRecord::Migration[7.2]
  def change
    create_table :user_fragrance_scores do |t|
      t.references :diagnosis, null: false, foreign_key: true
      t.integer :floral_score, null: false
      t.integer :citrus_score, null: false
      t.integer :oriental_score, null: false
      t.integer :spicy_score, null: false
      t.integer :herbal_score, null: false
      t.integer :woody_score, null: false

      t.timestamps
    end
  end
end
