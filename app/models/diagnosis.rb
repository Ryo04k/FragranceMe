class Diagnosis < ApplicationRecord
  belongs_to :user
  belongs_to :fragrance
  has_one :user_fragrance_score

  # ユーザーID、香りID、診断日付は必須
  validates :user_id, presence: true
  validates :fragrance_id, presence: true
  validates :diagnosis_date, presence: true


 # ユーザーと香りの情報を使って診断結果を保存するメソッド
 def self.create_with_scores(user, fragrance_name, scores)
  fragrance = Fragrance.find_by(name: fragrance_name)
  raise ActiveRecord::RecordNotFound, "指定された香りが見つかりませんでした。" unless fragrance

  ActiveRecord::Base.transaction do
    diagnosis = create!(
      user_id: user.id,
      fragrance_id: fragrance.id,
      diagnosis_date: Time.current
    )

    UserFragranceScore.create!(
      diagnosis_id: diagnosis.id,
      floral_score: scores[:floral].to_i,
      citrus_score: scores[:citrus].to_i,
      oriental_score: scores[:oriental].to_i,
      spicy_score: scores[:spicy].to_i,
      herbal_score: scores[:herbal].to_i,
      woody_score: scores[:woody].to_i
    )

    diagnosis
  end
rescue ActiveRecord::RecordInvalid => e
  raise "診断結果の保存に失敗しました: #{e.message}"
end
end
