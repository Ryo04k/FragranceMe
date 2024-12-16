class DiagnosesController < ApplicationController
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
    Rails.logger.info "回答のハッシュデータ: #{@user_answers.inspect}"
    @user_fragrance_form = UserFragranceForm.new

    # スコアの計算
    @scores = @user_fragrance_form.calculate_scores(@user_answers)
    Rails.logger.info "計算されたスコア: #{@scores.inspect}"

    # 一番スコアの高い香りを取得
    @recommended_fragrance = recommend_fragrance(@scores)

    # 高スコアの香りの画像を取得
    @recommended_fragrance_image = fetch_fragrance_image(@recommended_fragrance)

    # 診断結果を保存
    if @recommended_fragrance.any?
      begin
        # 香りの名前からIDを取得
        fragrance = Fragrance.find_by(name: @recommended_fragrance.first)

        if fragrance
          diagnosis = Diagnosis.create!(
            user_id: current_user.id,
            fragrance_id: fragrance.id,
            diagnosis_date: Time.current
          )

          # スコアを保存
          UserFragranceScore.create!(
            diagnosis_id: diagnosis.id,
            floral_score: @scores[:floral].to_i,
            citrus_score: @scores[:citrus].to_i,
            oriental_score: @scores[:oriental].to_i,
            spicy_score: @scores[:spicy].to_i,
            herbal_score: @scores[:herbal].to_i,
            woody_score: @scores[:woody].to_i
          )

          flash[:notice] = "診断結果が保存されました。"
        else
          flash[:alert] = "指定された香りが見つかりませんでした。"
        end
      rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = "診断結果の保存に失敗しました: #{e.message}"
      end
    else
      flash[:alert] = "推奨香りが見つかりませんでした。"
    end
  end

  def recommend_fragrance(scores)
    max_score = scores.values.max
    scores.select { |fragrance_name, score| score == max_score }.keys.map do |name|
      translate_fragrance_name(name)
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
end
