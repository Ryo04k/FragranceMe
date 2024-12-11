class Fragrance < ApplicationRecord
  has_many :diagnoses

  # 香りの名前は必須で、一意でなければならない
  validates :name, presence: true, uniqueness: true
  # 画像URLは必須
  validates :image_url, presence: true
end
