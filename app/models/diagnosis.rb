class Diagnosis < ApplicationRecord
  belongs_to :user
  belongs_to :fragrance
  has_one :user_fragrance_score

  validates :user_id, presence: true
  validates :fragrance_id, presence: true
  validates :diagnosis_date, presence: true


def self.create_with_scores(user, fragrance_id, scores)
  ActiveRecord::Base.transaction do
    diagnosis = create!(
      user_id: user.id,
      fragrance_id: fragrance_id,
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
  end
rescue ActiveRecord::RecordInvalid => e
  raise "診断結果の保存に失敗しました: #{e.message}"
end

def self.latest_for_user(user)
  user.diagnoses.includes(:fragrance, :user_fragrance_score).order(diagnosis_date: :desc).first
end

def user_scores
  [
    user_fragrance_score.floral_score,
    user_fragrance_score.citrus_score,
    user_fragrance_score.spicy_score,
    user_fragrance_score.oriental_score,
    user_fragrance_score.herbal_score,
    user_fragrance_score.woody_score
  ]
end
end
