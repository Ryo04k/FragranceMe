class Shop < ApplicationRecord
  has_many :shop_images, dependent: :destroy
  has_many :shop_bookmarks, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "address" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def simplified_address
    match_data = address.match(/(.*?[都道府県].*?[市区町村].*?)(\d+[-]\d+)?/)

    if match_data
      match_data[0].strip
    else
      "住所不明"
    end
  end

  # Geocoding setup
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }

  # shop_imageからimage属性を取得し、GoogleMapsAPIから画像を取得するためのURLを生成
  def photo_urls
    shop_images.map do |shop_image|
      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1200&photoreference=#{shop_image.image}&key=#{GoogleApi.api_key}"
    end
  end
end
