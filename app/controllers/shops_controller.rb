class ShopsController < ApplicationController
  before_action :set_ransack_query, only: [ :index, :search ]
  before_action :set_map_data, only: [ :index, :search ]

  def index;end

  def search
    render :index
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

  def show
    @shop = Shop.includes(:shop_images).find(params[:id])
    @shop_images = @shop.photo_urls
  end


  private

  def set_ransack_query
    @q = Shop.ransack(params[:q])
    if params[:q].present?
      @filtered_shops = @q.result(distinct: true).includes(:shop_images).page(params[:page]).per(12)
    else
      @filtered_shops = Shop.all.includes(:shop_images).page(params[:page]).per(12)
    end
  end

  def set_map_data
    @shops = @filtered_shops.map do |shop|
      shop.as_json(only: [ :id, :name, :latitude, :longitude, :address, :rating ]).merge(
        image: shop.shop_images.first&.image
      )
    end
    @shops_json = @shops.to_json
  end
end
