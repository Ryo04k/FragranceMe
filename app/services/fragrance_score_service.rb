module FragranceScoreConstants
  ANSWER_MAPPING = {
    "1"  => "初心者",
    "2"  => "ある程度詳しい",
    "3"  => "詳しい",
    "4"  => "アクティブ",
    "5"  => "仕事中心で忙しい",
    "6"  => "趣味に時間を使う",
    "7"  => "日常使い",
    "8"  => "特別な日",
    "9"  => "ビジネスシーン",
    "10" => "リラックスしたい時",
    "11" => "カジュアル",
    "12" => "キレイめ",
    "13" => "個性的",
    "14" => "シンプル",
    "15" => "女性向け",
    "16" => "男性向け",
    "17" => "特に無し",
    "18" => "フラワーブーケ",
    "19" => "フルーツバスケット",
    "20" => "スパイシー",
    "21" => "森の香り",
    "22" => "春",
    "23" => "夏",
    "24" => "秋",
    "25" => "冬",
    "26" => "フレッシュで爽やか",
    "27" => "落ち着いて知的",
    "28" => "華やかで女性らしい"
  }.freeze

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
      "リラックスしたい時" => { floral: 1, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 0 }
    },
    fashion: {
      "カジュアル" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "キレイめ" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 0, woody: 1 },
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
    season: {
      "春" => { floral: 2, citrus: 1, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "夏" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 1, woody: 0 },
      "秋" => { floral: 1, citrus: 1, oriental: 2, spicy: 1, herbal: 0, woody: 1 },
      "冬" => { floral: 0, citrus: 0, oriental: 2, spicy: 2, herbal: 0, woody: 2 }
    },
    impression: {
      "フレッシュで爽やか" => { floral: 1, citrus: 2, oriental: 0, spicy: 0, herbal: 2, woody: 0 },
      "落ち着いて知的" => { floral: 0, citrus: 0, oriental: 2, spicy: 2, herbal: 1, woody: 2 },
      "華やかで女性らしい" => { floral: 2, citrus: 1, oriental: 1, spicy: 0, herbal: 0, woody: 0 }
    }
  }.freeze
end

  class FragranceScoreService
    include FragranceScoreConstants

    def initialize(user_answers)
      @user_answers = user_answers
    end

    def calculate_scores
      total_scores = { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }

      @user_answers.each do |question_id, answer_content|
        scores = calculate_individual_scores(question_id, answer_content)

        total_scores.merge!(scores) { |key, old_val, new_val| old_val + new_val }
      end

      total_scores
    end

    private

    def calculate_individual_scores(question_id, answer_content)
      mapped_answer = ANSWER_MAPPING[answer_content]

      case question_id.to_i
      when 1 then SCORE_DATA[:expertise][mapped_answer] || default_scores
      when 2 then SCORE_DATA[:lifestyle][mapped_answer] || default_scores
      when 3 then SCORE_DATA[:scene][mapped_answer] || default_scores
      when 4 then SCORE_DATA[:fashion][mapped_answer] || default_scores
      when 5 then SCORE_DATA[:desired_fragrance][mapped_answer] || default_scores
      when 6 then SCORE_DATA[:image][mapped_answer] || default_scores
      when 7 then SCORE_DATA[:season][mapped_answer] || default_scores
      when 8 then SCORE_DATA[:impression][mapped_answer] || default_scores
      else default_scores
      end
    end

    def default_scores
      { floral: 0, citrus: 0, oriental: 0, spicy: 0, herbal: 0, woody: 0 }
    end
  end
