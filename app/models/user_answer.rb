class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :answer_id, presence: true
end
