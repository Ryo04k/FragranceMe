class UserFragranceForm
  include ActiveModel::Model

  attr_accessor :diagnosis_id, :user_answers

  validates :diagnosis_id, presence: true

  def calculate_scores
    Rails.logger.info "FragranceScoreServiceに渡す中身: #{user_answers.inspect}"
    FragranceScoreService.new(user_answers).calculate_scores
  end
end
