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

  SCORE_DATA = {
    expertise: {
      "初心者" => { floral: 2, citrus: 2, oriental: 1, spicy: 1, herbal: 2, woody: 1 },
      "ある程度詳しい" => { floral: 1, citrus: 1, oriental: 2, spicy: 2, herbal: 1, woody: 1 },
      "詳しい" => { floral: 1, citrus: 0, oriental: 2, spicy: 2, herbal: 0, woody: 2 }
    },
    lifestyle: {
      "アクティブ" => { floral: 2, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 1 },
      "仕事中心で忙しい" => { floral: 1, citrus: 1, oriental: 2, spicy: 1, herbal: 0, woody: 1 },
      "趣味に時間を使う" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 2, woody: 0 }
    },
    scene: {
      "日常使い" => { floral: 1, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 1 },
      "特別な日" => { floral: 1, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 0 },
      "ビジネスシーン" => { floral: 0, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 1 },
      "リラックスしたい時" => { floral: 1, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "デートの時" => { floral: 1, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 0 }
    },
    fashion: {
      "カジュアル" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "キレイめ" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 0, woody: 1 },
      "大人っぽい" => { floral: 1, citrus: 0, oriental: 2, spicy: 2, herbal: 0, woody: 2 },
      "個性的" => { floral: 1, citrus: 1, oriental: 1, spicy: 2, herbal: 1, woody: 1 },
      "シンプル" => { floral: 0, citrus: 1, oriental: 0, spicy: 0, herbal: 2, woody: 2 }
    },
    desired_fragrance: {
      "女性向け" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 1, woody: 0 },
      "男性向け" => { floral: 0, citrus: 1, oriental: 2, spicy: 2, herbal: 1, woody: 2 },
      "特に無し" => { floral: 1, citrus: 1, oriental: 1, spicy: 1, herbal: 1, woody: 1 }
    },
    image: {
      "フラワーブーケ" => { floral: 2, citrus: 0, oriental: 1, spicy: 0, herbal: 0, woody: 0 },
      "フルーツバスケット" => { floral: 0, citrus: 2, oriental: 0, spicy: 0, herbal: 0 },
      "スパイシー" => { floral: 0, citrus: 0, oriental: 2, spicy: 2, herbal: 0 },
      "森の香り" => { floral: 0, citrus: 0, oriental: 1, spicy: 1, herbal: 2 }
    },
    impression: {
      "フレッシュで爽やか" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 2, woody: 0 },
      "落ち着いて知的" => { floral: 0, citrus: 0, oriental: 2, spicy: 2, herbal: 1, woody: 2 },
      "華やかで女性らしい" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 0, woody: 0 }
    }
  }.freeze

  def calculate_scores(user_answers)
    total_scores = { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }

    user_answers.each do |question_id, answer_content|
      scores = calculate_individual_scores(question_id, answer_content)

      # 各スコアを合計
      total_scores.merge!(scores) { |key, old_val, new_val| old_val + new_val }
    end

    total_scores
  end

  private

  def calculate_individual_scores(question_id, answer_content)

    mapped_answer = ANSWER_MAPPING[answer_content] || answer_content

    case question_id.to_i
    when 1 then SCORE_DATA[:expertise][mapped_answer] || default_scores
    when 2 then SCORE_DATA[:lifestyle][mapped_answer] || default_scores
    when 3 then SCORE_DATA[:scene][mapped_answer] || default_scores
    when 4 then SCORE_DATA[:fashion][mapped_answer] || default_scores
    when 5 then SCORE_DATA[:desired_fragrance][mapped_answer] || default_scores
    when 6 then SCORE_DATA[:image][mapped_answer] || default_scores
    when 7 then SCORE_DATA[:impression][mapped_answer] || default_scores
    else default_scores
    end
  end

  def default_scores
    { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
  end
end
