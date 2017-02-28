class NrqsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @nrq = Nrq.new
  end

  def create
    @nrq = Nrq.new(nrq_params)
    @nrq.survey_id = params[:survey_id]
    if @nrq.save
      redirect_to edit_survey_path(@nrq.survey_id)
    else
      @survey = Survey.find(params[:survey_id])
      render :new
    end
  end

  def destroy
    @nrq = Nrq.find(params[:id])
    @nrq.destroy
    redirect_to :back
  end

  private

  def nrq_params
    params.require(:nrq).permit(:question_text, :min, :max, :required)
  end
end
