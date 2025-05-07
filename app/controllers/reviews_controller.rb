class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update destroy]
  before_action :set_review, only: %i[edit update destroy]

  def create
    @review = current_user.reviews.build(review_params)
    @review.save
  end

  def edit
    @shop = @review.shop
  end

  def update
    @shop = @review.shop
    @review = Review.find(params[:id])

    if @review.update(update_review_params)
      flash[:notice] = "口コミを更新しました。"
      redirect_to shop_path(@shop)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:body).merge(shop_id: params[:shop_id])
  end

  def update_review_params
    params.require(:review).permit(:body)
  end
end
