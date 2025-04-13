module DiagnosisSessionHandler
  extend ActiveSupport::Concern

  def save_diagnosis_from_session
    diagnosis_data = session[ApplicationController::DIAGNOSIS_DATA_KEY]
    return unless diagnosis_data.present?

    scores = diagnosis_data["score"]
    fragrance_id = diagnosis_data["fragrance_id"]

    Diagnosis.create_with_scores(current_user, fragrance_id, scores)
    session.delete(ApplicationController::DIAGNOSIS_DATA_KEY)
  end
end
