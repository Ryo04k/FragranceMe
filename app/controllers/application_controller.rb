class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  DIAGNOSIS_DATA_KEY = :diagnosis_data

  private

  def after_sign_in_path_for(resource_or_scope)
    shops_path
  end
end
