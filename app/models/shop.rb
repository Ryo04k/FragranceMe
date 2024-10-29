class Shop < ApplicationRecord
  has_many :shop_images, dependent: :destroy
end
