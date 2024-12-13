class Diagnosis < ApplicationRecord
  belongs_to :user
  belongs_to :fragrance
  has_one :user_fragrance_score

  # ユーザーID、香りID、診断日付は必須
  validates :user_id, presence: true
  validates :fragrance_id, presence: true
  validates :diagnosis_date, presence: true
end
