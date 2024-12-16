class UserFragranceScore < ApplicationRecord
  belongs_to :diagnosis

  # 診断IDは必須
  validates :diagnosis_id, presence: true
  # 各スコアは整数でなければならない
  validates :floral_score, :citrus_score, :oriental_score, :spicy_score, :herbal_score, :woody_score, numericality: { only_integer: true }
end
