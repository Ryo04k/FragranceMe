class UserFragranceForm
  include ActiveModel::Model

  attr_accessor :user_answers
  validates :user_answers, presence: true

  def calculate_scores
    FragranceScoreService.new(user_answers).calculate_scores
  end
end
