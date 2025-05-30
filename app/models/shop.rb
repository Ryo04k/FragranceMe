class Shop < ApplicationRecord
  has_many :shop_images, dependent: :destroy
  has_many :shop_bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :experienced_shops, -> { where(has_experience: true) }

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

  def photo_urls
    Rails.cache.fetch([ self, "photo_urls" ], expires_in: 1.week) do
      shop_images.map do |shop_image|
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=#{shop_image.image}&key=#{GoogleApi.api_key}"
      end
    end
  end
end
