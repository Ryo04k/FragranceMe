class Question < ApplicationRecord
  has_many :answers
  has_many :user_answers

  # 質問内容は必須で、一意でなければならない
  validates :content, presence: true, uniqueness: true
end
