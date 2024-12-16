class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  # ユーザーID、質問ID、および回答IDは必須
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :answer_id, presence: true
end
