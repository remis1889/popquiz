class McqsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @mcq = Mcq.new
    session[:mcq_params] = {} # initialize session
  end

  def create
    @survey = Survey.find(params[:survey_id])

    # save current params to session
    session[:mcq_params].deep_merge!(mcq_params) if params[:mcq]

    @mcq = Mcq.new(session[:mcq_params])
    @mcq.survey_id = params[:survey_id]
    @mcq.current_step = session[:mcq_step]

    # If there are no options for @mcq or
    # if the option count is updated, build @mcq.options
    if @mcq.option_count.to_i != @mcq.options.length
      @mcq.options = []
      @mcq.option_count.to_i.times { @mcq.options.build }
    end

    if params[:previous_button]
      @mcq.previous_step
    elsif @mcq.last_step?
      @mcq.save if @mcq.valid?
    else
      @mcq.next_step
    end

    session[:mcq_step] = @mcq.current_step

    # if @mcq is not saved, render 'new'
    if @mcq.new_record?
      render 'new'
    else # if @mcq is saved clear session and redirect
      session[:mcq_step] = session[:mcq_params] = nil
      redirect_to edit_survey_path(@mcq.survey_id)
    end
  end

  def destroy
    @mcq = Mcq.find(params[:id])
    @mcq.destroy

    redirect_back(fallback_location: root_path) # refresh the page after delete
  end

  private

  def mcq_params
    params.require(:mcq)
          .permit(:option_count, :question_text, :multiselect, :required, options_attributes: [:option_text])
  end
end
