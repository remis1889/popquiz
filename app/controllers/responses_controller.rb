class ResponsesController < ApplicationController

  before_action :set_survey, only: [:new, :create]

  def new
    @response = Response.new

    @survey.mcqs.each { |mcq| @response.answers.build(question_id: mcq.id, question_type: 'Mcq') }
    @survey.nrqs.each { |nrq| @response.answers.build(question_id:nrq.id, question_type: 'Nrq') }
    @questions = @survey.question_details
  end

  def create
    @response = Response.new(response_params)
    @response.survey_id = @survey.id

    build_checkbox_answers

    if @response.valid?
      @response.remove_blanks
      @response.save
      redirect_to root_path
    else
      rebuild_form
      @questions = @survey.question_details
      render :new
    end
  end

  private

  def response_params
    params.require(:response).permit(answers_attributes:
      [:question_id, :question_type, :answer_entry, answer_entry: []])
  end

  def build_checkbox_answers
    response_params[:answers_attributes].values.each do |a|
      if (a[:answer_entry].is_a? Array) && (a[:answer_entry] != [''])
        a[:answer_entry] -= ['']

        a[:answer_entry].map { |answer| @response.answers.build(  question_id: a[:question_id],
          question_type: a[:question_type],
          answer_entry: answer
        )}

        parent_answer = @response.answers.find{ |ans| ans[:question_id] == a[:question_id].to_i && ans[:answer_entry].nil? }
        @response.answers.destroy(parent_answer) if parent_answer
      end
    end
  end

  def rebuild_form
    mcq_ans = @response.answers.select{|ans| ans[:question_type] == 'Mcq'}

    checked = Hash.new { |hash, key| hash[key] = [] }
    mcq_ans.map do |m|
      checked[m.question_id] << m.answer_entry if m.answer_entry
      @response.answers.destroy(m) if checked[m.question_id].length > 1
    end

    @response.answers.each { |ans| ans.checked = checked[ans.question_id] }
  end

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
end
