# db/seeds.rb

# 香りデータの作成
fragrances = Fragrance.create([
  { name: 'フローラル', image_url: 'floral.jpg' },
  { name: '柑橘', image_url: 'citrus.jpg' },
  { name: 'オリエンタル', image_url: 'oriental.jpg' },
  { name: 'スパイシー', image_url: 'spicy.jpg' },
  { name: 'ハーブ', image_url: 'herbal.jpg' },
  { name: 'ウッディ', image_url: 'woody.jpg' }
])

# 質問データの作成
questions = Question.create([
  { content: 'あなたは香りに詳しいですか？' },
  { content: '普段の生活スタイルを教えて下さい。' },
  { content: 'どのようなシーンに使いたいですか？' },
  { content: '好きなファッションを教えて下さい。' },
  { content: 'どのような香りをお探しですか？' },
  { content: 'あなたが心惹かれる香りのイメージはどれですか？' },
  { content: '周囲にどのような印象を与えたいですか？' }
])

# 回答データの作成
answers = Answer.create([
  { question: questions[0], content: '初心者' },
  { question: questions[0], content: 'ある程度詳しい' },
  { question: questions[0], content: '詳しい' },

  { question: questions[1], content: 'アクティブ' },
  { question: questions[1], content: '仕事中心で忙しい' },
  { question: questions[1], content: '趣味に時間を使う' },

  { question: questions[2], content: '日常使い' },
  { question: questions[2], content: '特別な日' },
  { question: questions[2], content: 'ビジネスシーン' },
  { question: questions[2], content: 'リラックスしたい時' },
  { question: questions[2], content: 'デートの時' },

  { question: questions[3], content: 'カジュアル' },
  { question: questions[3], content: 'キレイめ' },
  { question: questions[3], content: '大人っぽい' },
  { question: questions[3], content: '個性的' },
  { question: questions[3], content: 'シンプル' },

  { question: questions[4], content: '女性向け' },
  { question: questions[4], content: '男性向け' },
  { question: questions[4], content: '特に無し' },

  { question: questions[5], content: 'フラワーブーケ' },
  { question: questions[5], content: 'フルーツバスケット' },
  { question: questions[5], content: 'スパイシー' },
  { question: questions[5], content: '森の香り' },

  { question: questions[6], content: 'フレッシュで爽やか' },
  { question: questions[6], content: '落ち着いて知的' },
  { question: questions[6], content: '華やかで女性らしい' }
])

# サンプルユーザーの作成
user = User.find_or_create_by(email: 'test@example.com') do |u|
  u.name = 'test_user'
  u.password = 'password' # パスワードを設定
  u.password_confirmation = 'password' # 確認用パスワードも設定
end

# サンプル診断の作成
diagnosis = Diagnosis.create(user: user, fragrance: fragrances.first, diagnosis_date: Time.current)

# サンプルユーザー回答の作成
UserAnswer.create([
  { user: user, question: questions[0], answer: answers[0] }, # あなたは香りに詳しいですか？ - 初心者
  { user: user, question: questions[1], answer: answers[1] }, # 普段の生活スタイルを教えてください。 - 仕事中心で忙しい
  { user: user, question: questions[2], answer: answers[2] }, # どのようなシーンに使いたいですか？ - ビジネスシーン
  { user: user, question: questions[3], answer: answers[3] }, # 好きなファッションを教えてください。 - カジュアル
  { user: user, question: questions[4], answer: answers[4] }, # どのような香りをお探しですか？ - 男性向け
  { user: user, question: questions[5], answer: answers[5] }, # あなたが心惹かれる香りのイメージはどれですか？ - フルーツバスケット
  { user: user, question: questions[6], answer: answers[6] }  # 周囲にどのような印象を与えたいですか？ - フレッシュで爽やか
])

# サンプルスコアの作成
UserFragranceScore.create(
  diagnosis: diagnosis,
  floral_score: 8,
  citrus_score: 5,
  oriental_score: 7,
  spicy_score: 3,
  herbal_score: 6,
  woody_score: 4
)
