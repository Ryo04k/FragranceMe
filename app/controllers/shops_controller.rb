class ShopsController < ApplicationController
  before_action :set_ransack_query, only: [ :index ]

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

  def map
    @shops = Shop.includes(:shop_images)
    @shops_json = generate_shops_json(@shops)
  end

  def show
    @shop = Shop.includes(:shop_images).find_by(id: params[:id])
    @review = Review.new
    @reviews = @shop.reviews.includes(:user).order(created_at: :desc)

    if @shop
      @shop_images = @shop.photo_urls
    else
      redirect_to shops_path
    end
  end

  def bookmarks
    @shop_bookmarks = current_user.shop_bookmarks.includes(:shop).order(created_at: :desc)
  end


  private

  def set_ransack_query
    @q = Shop.ransack(params[:q])
    @filtered_shops = fetch_filtered_shops
  end

  def fetch_filtered_shops
    shops = params[:q].present? ? @q.result(distinct: true) : Shop.all
    paginate_shops(shops)
  end

  def paginate_shops(shops)
    shops.page(params[:page]).per(12)
  end

  def generate_shops_json(shops)
    shops.map do |shop|
      first_image = shop.shop_images.first&.image
      shop.as_json(only: [ :id, :name, :latitude, :longitude, :address, :rating ]).merge(image: first_image)
    end
  end
end
