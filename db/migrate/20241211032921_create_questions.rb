class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.string :content, null: false
      t.string :image_url

      t.index :content, unique: true
      t.timestamps
    end
  end
end
