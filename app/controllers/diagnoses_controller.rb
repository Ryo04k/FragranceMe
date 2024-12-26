class DiagnosesController < ApplicationController
  before_action :initialize_user_fragrance_form, only: [ :start, :result ]
  before_action :initialize_user_answers, only: [ :answer_question ]
  before_action :set_question, only: [ :show_question ]

  # セッションに保存する診断結果のキー
  DIAGNOSIS_DATA_KEY = :diagnosis_data

  # 診断の開始時にフォームオブジェクトを初期化
  def start;end

  # ユーザーの質問への回答をセッションに保存し、次の質問または結果ページにリダイレクト
  def answer_question
    session[:user_answers][params[:question_id]] = params[:answer]
    redirect_to next_question_or_results(params[:question_id])
  end

  # ユーザーの回答に基づいて診断結果を計算し、スコアの高い香りを表示
  def result
    @user_answers = session[:user_answers] || {}
    Rails.logger.info "resultスコアの中身: #{@user_answers.inspect}"

    @scores = @user_fragrance_form.calculate_scores
    Rails.logger.info "スコアの中身: #{@scores.inspect}"

    @recommended_fragrance_id = recommend_fragrance(@scores)
    Rails.logger.info "テキスト: #{@recommended_fragrance_id.inspect}"

    if @recommended_fragrance_id
      @recommended_fragrance = Fragrance.find(@recommended_fragrance_id)
      save_diagnosis_or_session
    else
      flash[:alert] = "診断結果が保存出来ませんでした。"
    end
  end

  private

  def initialize_user_fragrance_form
    @user_fragrance_form = UserFragranceForm.new(diagnosis_id: params[:diagnosis_id], user_answers: session[:user_answers] || {})
  end

  # ユーザーの回答をセッションに保存
  def initialize_user_answers
    session[:user_answers] ||= {}
  end

  # 質問を取得し、紐づけられた回答を取得
  def set_question
    @question = Question.find(params[:id])
    @answers = @question.answers
  end

  # 次の質問が存在する場合はその質問のパスを返し、存在しない場合は診断結果のパスを返す
  def next_question_or_results(current_question_id)
    next_question_id = current_question_id.to_i + 1
    Question.exists?(next_question_id) ? question_diagnoses_path(next_question_id) : result_diagnoses_path
  end

  def recommend_fragrance(scores)
    max_score = scores.values.max
    top_fragrance_name = scores.select { |fragrance_name, score| score == max_score }.keys.first
    Fragrance.find_by(image_url: "#{top_fragrance_name}.jpg")&.id
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
      Diagnosis.create_with_scores(current_user, @recommended_fragrance_id, @scores)
    rescue => e
      Rails.logger.error "診断結果の保存に失敗しました: #{e.message}"
      flash[:alert] = "診断結果の保存に失敗しました。"
    end
  end

  # 未ログインユーザーの場合、診断結果をセッションに保存
  def save_to_session
    session[DIAGNOSIS_DATA_KEY] = {
      fragrance_id: @recommended_fragrance_id,
      score: @scores
    }
    Rails.logger.info "セッションデータの中身: #{session.inspect}"
  end
end
