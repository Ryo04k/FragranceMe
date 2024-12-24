class DiagnosesController < ApplicationController
  # セッションに保存する診断結果のキー
  DIAGNOSIS_DATA_KEY = :diagnosis_data

  # 診断の開始時にフォームオブジェクトを初期化
  def start
    @user_fragrance_form = UserFragranceForm.new
  end

  # 質問と紐づけられた回答を表示
  def show_question
    @question = Question.find(params[:id])
    @answers = @question.answers
  end

  # ユーザーの質問への回答をセッションに保存し、次の質問または結果ページにリダイレクト
  def answer_question
    initialize_user_answers
    session[:user_answers][params[:question_id]] = params[:answer]

    redirect_to next_question_or_results(params[:question_id])
  end

  # ユーザーの回答に基づいて診断結果を計算し、スコアの高い香りを表示
  def result
    @user_answers = session[:user_answers] || {}
    @user_fragrance_form = UserFragranceForm.new

    # ユーザーの回答に基づいてフォームオブジェクト内でスコアを計算し@scoresに代入
    @scores = @user_fragrance_form.calculate_scores(@user_answers)

    # 最も高いスコアを持つ香りの名前（例:["フローラル"]）を代入
    @recommended_fragrance = recommend_fragrance(@scores)

    # 検索結果に表示する画像のURL（例:"floral.jpg"）を代入
    @recommended_fragrance_image = fetch_fragrance_image(@recommended_fragrance)

    if @recommended_fragrance.any?
      save_diagnosis_or_session
    else
      flash[:alert] = "診断結果が保存出来ませんでした。"
    end
  end

  private

  # session[:user_answers] が存在しない場合、空のハッシュ {} を作成して session[:user_answers] に代入
  def initialize_user_answers
    session[:user_answers] ||= {}
  end

  # 次の質問が存在する場合はその質問のパスを返し、存在しない場合は診断結果のパスを返す
  def next_question_or_results(current_question_id)
    next_question_id = current_question_id.to_i + 1
    Question.exists?(next_question_id) ? question_diagnoses_path(next_question_id) : result_diagnoses_path
  end

  # scoresハッシュから最も高いスコアをmax_scoreに代入し、そのスコアを持つ香りの名前を翻訳して返す
  def recommend_fragrance(scores)
    max_score = scores.values.max
    scores.select { |fragrance_name, score| score == max_score }.keys.map do |name|
      translate_fragrance_name(name)
    end
  end

  # 香りの名前を日本語に変換
  def translate_fragrance_name(name)
    case name
    when :herbal then "ハーブ"
    when :floral then "フローラル"
    when :citrus then "柑橘"
    when :oriental then "オリエンタル"
    when :spicy then "スパイシー"
    when :woody then "ウッディ"
    else name.to_s
    end
  end

  # Fragranceモデルから合致する名前の一番目のレコードを取得
  def fetch_fragrance_image(recommended_fragrance)
    Fragrance.find_by(name: recommended_fragrance.first) if recommended_fragrance.any?
  end

  # 診断結果をデータベースまたはセッションに保存
  def save_diagnosis_or_session
    if current_user
      save_diagnosis
    else
      save_to_session
    end
  end

  # ログインユーザーの場合、診断結果をデータベースに保存
  def save_diagnosis
    begin
      Diagnosis.create_with_scores(current_user, @recommended_fragrance.first, @scores)
    rescue => e
      Rails.logger.error "診断結果の保存に失敗しました: #{e.message}"
      flash[:alert] = "診断結果の保存に失敗しました。"
    end
  end

  # 未ログインユーザーの場合、診断結果をセッションに保存
  # fragrance_idには、おすすめのfragrance_id、scoreには診断結果のスコアを保存
  def save_to_session
    session[DIAGNOSIS_DATA_KEY] = {
      fragrance_name: @recommended_fragrance.first,
      score: @scores
    }
    Rails.logger.info "セッションデータの中身: #{session.inspect}"
  end
end
