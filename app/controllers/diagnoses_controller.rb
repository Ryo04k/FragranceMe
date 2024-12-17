class DiagnosesController < ApplicationController
  DIAGNOSIS_DATA_KEY = :diagnosis_data

  def start
    @user_fragrance_form = UserFragranceForm.new
  end

  def show_question
    @question = Question.find(params[:id])
    @answers = @question.answers
  end

  def answer_question
    initialize_user_answers
    session[:user_answers][params[:question_id]] = params[:answer]

    redirect_to next_question_or_results(params[:question_id])
  end

  def result
    @user_answers = session[:user_answers] || {}
    @user_fragrance_form = UserFragranceForm.new

    # 各スコアを計算
    @scores = @user_fragrance_form.calculate_scores(@user_answers)
    @recommended_fragrance = recommend_fragrance(@scores)
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

  def next_question_or_results(current_question_id)
    next_question_id = current_question_id.to_i + 1
    Question.exists?(next_question_id) ? question_diagnoses_path(next_question_id) : result_diagnoses_path
  end

  def recommend_fragrance(scores)
    max_score = scores.values.max
    scores.select { |fragrance_name, score| score == max_score }.keys.map do |name|
      translate_fragrance_name(name)
    end
  end

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

  def fetch_fragrance_image(recommended_fragrance)
    Fragrance.find_by(name: recommended_fragrance.first) if recommended_fragrance.any?
  end

  def save_diagnosis_or_session
    if current_user
      save_diagnosis
    else
      save_to_session
    end
  end

  def save_diagnosis
    begin
      Diagnosis.create_with_scores(current_user, @recommended_fragrance.first, @scores)
    rescue => e
      Rails.logger.error "診断結果の保存に失敗しました: #{e.message}"
      flash[:alert] = "診断結果の保存に失敗しました。"
    end
  end

  def save_to_session
    session[DIAGNOSIS_DATA_KEY] = {
      fragrance_id: @recommended_fragrance.first,
      score: @scores
    }
    Rails.logger.info "セッションデータの中身: #{session.inspect}"
  end
end
