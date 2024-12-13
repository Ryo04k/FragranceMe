class UserFragranceForm
  include ActiveModel::Model

  ANSWER_MAPPING = {
    "1" => "初心者",
    "2" => "ある程度詳しい",
    "3" => "詳しい",
    "4" => "アクティブ",
    "5" => "仕事中心で忙しい",
    "6" => "趣味に時間を使う",
    "7" => "日常使い",
    "8" => "特別な日",
    "9" => "ビジネスシーン",
    "10" => "リラックスしたい時",
    "11" => "デートの時",
    "12" => "カジュアル",
    "13" => "キレイめ",
    "14" => "大人っぽい",
    "15" => "個性的",
    "16" => "シンプル",
    "17" => "女性向け",
    "18" => "男性向け",
    "19" => "特に無し",
    "20" => "フラワーブーケ",
    "21" => "フルーツバスケット",
    "22" => "スパイシー",
    "23" => "森の香り",
    "24" => "フレッシュで爽やか",
    "25" => "落ち着いて知的",
    "26" => "華やかで女性らしい"
  }

  attr_accessor :diagnosis_id, :user_answers

  validates :diagnosis_id, presence: true

  def calculate_scores(user_answers)
    total_scores = { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }

    user_answers.each do |question_id, answer_content|
      Rails.logger.debug "Expertise answer content: #{answer_content}"
      scores = case question_id
               when "1" then expertise_scores(answer_content)
               when "2" then lifestyle_scores(answer_content)
               when "3" then scene_scores(answer_content)
               when "4" then fashion_scores(answer_content)
               when "5" then desired_fragrance_scores(answer_content)
               when "6" then image_scores(answer_content)
               when "7" then impression_scores(answer_content)
               else { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
               end

      # 各スコアを合計
      total_scores.merge!(scores) { |key, old_val, new_val| old_val + new_val }

      Rails.logger.debug "Question ID: #{question_id}, Answer: #{answer_content}, Total Scores: #{total_scores.inspect}"
    end

    Rails.logger.debug "Final calculated scores: #{total_scores.inspect}"
    total_scores
  end

  private

  def expertise_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "初心者" => { floral: 2, citrus: 2, oriental: 1, spicy: 1, herbal: 2, woody: 1 },
      "ある程度詳しい" => { floral: 1, citrus: 1, oriental: 2, spicy: 2, herbal: 1, woody: 1 },
      "詳しい" => { floral: 1, citrus: 0, oriental: 2, spicy: 2, herbal: 0, woody: 2 }
    }

    Rails.logger.debug "Expertise answer content: #{mapped_answer}"
    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end

  def lifestyle_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "アクティブ" => { floral: 2, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 1 },
      "仕事中心で忙しい" => { floral: 1, citrus: 1, oriental: 2, spicy: 1, herbal: 0, woody: 1 },
      "趣味に時間を使う" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 2, woody: 0 }
    }

    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end

  def scene_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "日常使い" => { floral: 1, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 1 },
      "特別な日" => { floral: 1, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 0 },
      "ビジネスシーン" => { floral: 0, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 1 },
      "リラックスしたい時" => { floral: 1, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "デートの時" => { floral: 1, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 0 }
    }

    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end

  def fashion_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "カジュアル" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "キレイめ" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 0, woody: 1 },
      "大人っぽい" => { floral: 1, citrus: 0, oriental: 2, spicy: 2, herbal: 0, woody: 2 },
      "個性的" => { floral: 1, citrus: 1, oriental: 1, spicy: 2, herbal: 1, woody: 1 },
      "シンプル" => { floral: 0, citrus: 1, oriental: 0, spicy: 0, herbal: 2, woody: 2 }
    }

    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end

  def desired_fragrance_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "女性向け" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 1, woody: 0 },
      "男性向け" => { floral: 0, citrus: 1, oriental: 2, spicy: 2, herbal: 1, woody: 2 },
      "特に無し" => { floral: 1, citrus: 1, oriental: 1, spicy: 1, herbal: 1, woody: 1 }
    }

    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end

  def image_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "フラワーブーケ" => { floral: 2, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 0 },
      "フルーツバスケット" => { floral: 0, citrus: 2, oriental: 0, spicy: 0, herbal: 0 },
      "スパイシー" => { floral: 0, citrus: 0, oriental: 2, spicy: 2, herbal: 0 },
      "森の香り" => { floral: 0, citrus: 0, oriental: 1, spicy: 1, herbal: 2 }
    }

    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end

  def impression_scores(answer_content)
    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    scores = {
      "フレッシュで爽やか" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 2, woody: 0 },
      "落ち着いて知的" => { floral: 0, citrus: 0, oriental: 2, spicy: 2, herbal: 1, woody: 2 },
      "華やかで女性らしい" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 0, woody: 0 }
    }

    scores[mapped_answer] || { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end
end
