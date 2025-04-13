class Fragrance < ApplicationRecord
  has_many :diagnoses

  validates :name, presence: true, uniqueness: true

  validates :image_url, presence: true
end
