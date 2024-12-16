class Answer < ApplicationRecord
  belongs_to :question
  has_many :user_answers

  # 回答内容は必須
  validates :content, presence: true
end
