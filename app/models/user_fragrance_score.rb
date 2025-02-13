class UserFragranceScore < ApplicationRecord
  belongs_to :diagnosis

  validates :diagnosis_id, presence: true
  validates :floral_score, :citrus_score, :oriental_score, :spicy_score, :herbal_score, :woody_score, numericality: { only_integer: true }
end
