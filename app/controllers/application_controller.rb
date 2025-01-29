class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # 診断結果のセッションデータ
  DIAGNOSIS_DATA_KEY = :diagnosis_data

  private

  # ログイン後のリダイレクト先を設定
  def after_sign_in_path_for(resource_or_scope)
    shops_path
  end
end
