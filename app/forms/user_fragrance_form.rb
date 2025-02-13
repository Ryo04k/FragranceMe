class UserFragranceForm
  include ActiveModel::Model

  attr_accessor :diagnosis_id, :user_answers

  validates :diagnosis_id, presence: true

  def calculate_scores
    FragranceScoreService.new(user_answers).calculate_scores
  end
end
