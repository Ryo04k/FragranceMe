class ReviewsController < ApplicationController
  def create
    @review = current_user.reviews.build(review_params)
    @review.save
  end

  def destroy
    @review = current_user.reviews.find(params[:id])
    @review.destroy!
  end

  private

  def review_params
    params.require(:review).permit(:body).merge(shop_id: params[:shop_id])
  end
end
