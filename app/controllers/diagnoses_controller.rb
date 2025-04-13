class DiagnosesController < ApplicationController
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
    session[:user_answers][params[:question_id].to_sym] = params[:answer]
    Rails.logger.info "テキスト: #{session[:user_answers].inspect}"

    redirect_to next_question_or_results(params[:question_id])
  end

  def result
    initialize_user_fragrance_form
    @scores = @user_fragrance_form.calculate_scores
    @recommended_fragrance = find_recommended_fragrance(@scores)

    if @recommended_fragrance
      save_diagnosis_or_session
    else
      flash.now[:danger] = "診断結果を保存出来ませんでした。"
      ender :new, status: :unprocessable_entity
    end
  end

  private

  def initialize_user_fragrance_form
    @user_fragrance_form = UserFragranceForm.new(user_answers: session[:user_answers])
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

  def find_recommended_fragrance(scores)
    top_fragrance_name = scores.key(scores.values.max)
    recommended_fragrance = Fragrance.find_by(image_url: "#{top_fragrance_name}.jpg")

    recommended_fragrance
  end

  def save_diagnosis_or_session
    if current_user
      Diagnosis.create_with_scores(current_user, @recommended_fragrance.id, @scores)
    else
      session[DIAGNOSIS_DATA_KEY] = {
        fragrance_id: @recommended_fragrance.id,
        score: @scores
      }
    end
  end
end
