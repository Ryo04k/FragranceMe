class Shop < ApplicationRecord
  has_many :shop_images, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end
end
