class Shop < ApplicationRecord
  has_many :shop_images, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  # shop_imageからimage属性を取得し、GoogleMapsAPIから画像を取得するためのURLを生成
  def photo_urls
    shop_images.map do |shop_image|
      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{shop_image.image}&key=#{GoogleApi.api_key}"
    end
  end

end
