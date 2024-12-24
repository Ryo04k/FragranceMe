module DiagnosisSessionHandler
  extend ActiveSupport::Concern

  # DiagnosisSessionHandlerがincludeされたコントローラーにafter_actionで呼び出される
  # included do
  #   after_action :save_diagnosis_from_session, only: [:create]
  # end

  # 診断結果のセッションデータが存在する場合は、その結果をcreate_with_scoresに渡して診断結果をデータベースに保存
  def save_diagnosis_from_session
    if session[ApplicationController::DIAGNOSIS_DATA_KEY].present?
      diagnosis_data = session[ApplicationController::DIAGNOSIS_DATA_KEY]
      Rails.logger.debug "diagnosis_dataの中身 #{diagnosis_data.inspect}"
      Rails.logger.debug "ユーザー情報 #{current_user.inspect}"

      scores = diagnosis_data["score"].transform_keys(&:to_sym)
      fragrance_name = diagnosis_data["fragrance_name"]

      Diagnosis.create_with_scores(current_user, fragrance_name, scores)
      session.delete(ApplicationController::DIAGNOSIS_DATA_KEY)
    end
  end
end
