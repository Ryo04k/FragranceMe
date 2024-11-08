class ShopsController < ApplicationController
  before_action :set_ransack_query, only: [ :search, :map ]

  def search
    @shops = Shop.includes(:shop_images).all.map do |shop|
      shop.as_json(only: [ :id, :name, :latitude, :longitude, :address, :rating ]).merge(
        image: shop.shop_images.first&.image
      )
    end
    @shops_json = @shops.to_json
  end

def list
  @latitude = params[:latitude].to_f
  @longitude = params[:longitude].to_f
  @radius = (params[:radius] || 5).to_f

  @nearby_shops = Shop.includes(:shop_images).near([ @latitude, @longitude ], @radius, units: :km).limit(10)

  @nearby_shops_json = @nearby_shops.map do |shop|
    shop.as_json(only: [ :id, :name, :latitude, :longitude, :address, :rating ]).merge(
      image: shop.shop_images.first&.image
    )
  end

  render json: @nearby_shops_json
end

def show;end


  private

  def set_ransack_query
    @q = Shop.ransack(params[:q])
    if params[:q].present?
      @filtered_shops = @q.result(distinct: true) # 検索条件がある場合のみ検索結果を設定
    else
      @filtered_shops = [] # 検索条件がない場合は空の配列に設定
    end
  end
end
