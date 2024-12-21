class ProfilesController < ApplicationController
  before_action :authenticate_user!, :set_user

  def show
    @latest_diagnosis = Diagnosis.latest_for_user(@user)
    @scores = @latest_diagnosis.user_scores if @latest_diagnosis
  end


  private

  def set_user
    @user = current_user
  end
end
