class DiagnosesController < ApplicationController
  before_action :initialize_user_fragrance_form, only: [ :start, :result ]
  before_action :initialize_user_answers, only: [ :answer_question ]
  before_action :set_question, only: [ :show_question ]

  DIAGNOSIS_DATA_KEY = :diagnosis_data

  def start;end

  def show_question
    @total_questions = Question.count
    @current_question_id = params[:id].to_i
    @previous_question_id = @current_question_id - 1
  end

  def answer_question
    session[:user_answers][params[:question_id]] = params[:answer]
    redirect_to next_question_or_results(params[:question_id])

  end

  def result
    @scores = @user_fragrance_form.calculate_scores

    @recommended_fragrance_id = recommend_fragrance(@scores)

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

  def initialize_user_answers
    session[:user_answers] ||= {}
  end

  def set_question
    @question = Question.find(params[:id])
    @answers = @question.answers
  end

  def next_question_or_results(current_question_id)
    next_question_id = current_question_id.to_i + 1
    Question.exists?(next_question_id) ? question_diagnoses_path(next_question_id) : result_diagnoses_path
  end

  def recommend_fragrance(scores)
    max_score = scores.values.max
    top_fragrance_name = scores.select { |fragrance_name, score| score == max_score }.keys.first
    Fragrance.find_by(image_url: "#{top_fragrance_name}.jpg")&.id
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
      Diagnosis.create_with_scores(current_user, @recommended_fragrance_id, @scores)
    rescue => e
      flash[:alert] = "診断結果の保存に失敗しました。"
    end
  end

  def save_to_session
    session[DIAGNOSIS_DATA_KEY] = {
      fragrance_id: @recommended_fragrance_id,
      score: @scores
    }
  end
end
