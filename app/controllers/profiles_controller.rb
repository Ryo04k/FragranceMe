class ProfilesController < ApplicationController
  before_action :authenticate_user!, :set_user

  def show
    @latest_diagnosis = Diagnosis.latest_for_user(@user)
    @scores = @latest_diagnosis.user_scores if @latest_diagnosis
  end

  def update
    if @user.update(user_params)
       flash.now[:success] = "プロフィールを更新しました。"
       redirect_to profile_path
    else
      flash.now[:danger] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
