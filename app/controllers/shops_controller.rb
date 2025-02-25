class ShopsController < ApplicationController
  before_action :authenticate_user!, only: [ :bookmarks ]
  before_action :set_ransack_query, only: [ :index ]

  def index;end

  def search
    render :index
  end

  def list
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
    @radius = (params[:radius] || 2).to_f

    @nearby_shops = Shop.includes(:shop_images).near([ @latitude, @longitude ], @radius, units: :km).limit(6)

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

  def fetch_shops
    params[:q].present? ? @q.result(distinct: true) : Shop.all
  end

  def fetch_filtered_shops
    shops = fetch_shops
    shops = filter_experienced_shops(shops)

    sort_param = params.dig(:q, :s)

    if sort_param.present?
      shops = apply_sorting(shops, sort_param)
    end

    paginate_shops(shops)
  end

  def filter_experienced_shops(shops) # オリジナル香水ショップのみフィルタリング
    return shops unless params.dig(:q, :has_experience_eq) == "true"

    shops.experienced_shops
  end

  def apply_sorting(shops, sort_param)
    case sort_param
    when "rating"
      shops.order(rating: :desc)
    when "reviews"
      shops
      .left_joins(:reviews)
      .select("shops.*, COUNT(reviews.id) AS reviews_count")
      .group("shops.id")
      .order("COUNT(reviews.id) DESC")
    else
      shops
    end
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
