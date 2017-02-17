class ResultsController < ApplicationController
  before_action :load_lesson, :logged_in_user, only: :show

  def show
    if params[:lesson]
      if @lesson.update_attributes lesson_params
        @lesson.grade_lesson
      else
        flash[:danger] = t ".update_failed"
        redirect_to :back
      end
    end
  end

  private
    def lesson_params
      params.require(:lesson).permit results_attributes: [:id, :answer_id]
    end
end
