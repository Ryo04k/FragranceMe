class DiagnosesController < ApplicationController

  def start
    @user_fragrance_form = UserFragranceForm.new
  end

  def show_question
    @question = Question.find(params[:id]) # データベースから特定の質問を検索して格納
    @answers = @question.answers # 取得した質問に紐づいた回答リストを格納
  end


  def answer_question
    session[:user_answers] ||= {}
    session[:user_answers][params[:question_id]] = params[:answer]
    Rails.logger.debug "Current session data: #{session[:user_answers].inspect}"

    redirect_to next_question_or_results(params[:question_id])
  end

  def result
    @user_answers = session[:user_answers] || {}
    @user_fragrance_form = UserFragranceForm.new

    # スコアの計算
    @scores = @user_fragrance_form.calculate_scores(@user_answers)
    Rails.logger.debug "Calculated scores: #{@scores.inspect}"

    # 一番スコアの高い香りを取得
    @recommended_fragrance = recommend_fragrance(@scores)
    Rails.logger.debug "Recommended fragrance: #{@recommended_fragrance.inspect}"

    # 高スコアの香りの画像を取得
    @recommended_fragrance_image = fetch_fragrance_image(@recommended_fragrance)
    Rails.logger.debug "Recommended fragrance image: #{@recommended_fragrance_image.inspect}"
  end

  private

  def next_question_or_results(current_question_id)
    next_question_id = current_question_id.to_i + 1
    Question.exists?(next_question_id) ? question_diagnoses_path(next_question_id) : result_diagnoses_path
  end

  def recommend_fragrance(scores)
    max_score = scores.values.max
    scores.select { |k, v| v == max_score }.keys.map do |name|
      # ここで日本語に変換
      case name
      when :herbal then 'ハーブ'
      when :floral then 'フローラル'
      when :citrus then '柑橘'
      when :oriental then 'オリエンタル'
      when :spicy then 'スパイシー'
      when :woody then 'ウッディ'
      else name.to_s
      end
    end
  end

  def fetch_fragrance_image(recommended_fragrance)
    Fragrance.find_by(name: recommended_fragrance.first) if recommended_fragrance.any?
  end
end
