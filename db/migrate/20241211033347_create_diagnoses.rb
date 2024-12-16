class CreateDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnoses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fragrance, null: false, foreign_key: true
      t.datetime :diagnosis_date, null: false

      t.timestamps
    end
  end
end
