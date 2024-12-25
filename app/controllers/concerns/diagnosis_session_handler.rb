module DiagnosisSessionHandler
  extend ActiveSupport::Concern

  # 診断結果のセッションデータが存在する場合は、その結果をcreate_with_scoresに渡して診断結果をデータベースに保存
  def save_diagnosis_from_session
    diagnosis_data = session[ApplicationController::DIAGNOSIS_DATA_KEY]
    return unless diagnosis_data.present?

    Rails.logger.debug "diagnosis_dataの中身 #{diagnosis_data.inspect}"
    Rails.logger.debug "ユーザー情報 #{current_user.inspect}"

    scores = diagnosis_data["score"].transform_keys(&:to_sym)
    fragrance_id = diagnosis_data["fragrance_id"]

    Diagnosis.create_with_scores(current_user, fragrance_id, scores)
    session.delete(ApplicationController::DIAGNOSIS_DATA_KEY)
  end
end
