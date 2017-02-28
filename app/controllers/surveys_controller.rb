class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update]

  def index
    @surveys = Survey.all.includes(:mcqs, :nrqs, :responses)
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to edit_survey_path(@survey.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:survey][:question_type] == '0'
      session[:current_step] = session[:mcq_params] = nil
      redirect_to new_survey_mcq_path(@survey.id)
    elsif params[:survey][:question_type] == '1'
      redirect_to new_survey_nrq_path(@survey.id)
    end
  end

  def show
    @mcqs = @survey.mcqs
    @nrqs = @survey.nrqs
    @results = @survey.result_count
  end

  private

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def set_survey
    @survey = Survey.find(params[:id])
  end
end
