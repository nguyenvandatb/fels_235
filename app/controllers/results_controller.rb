class ResultsController < ApplicationController
  before_action :load_lesson, :load_category, :logged_in_user, only: :show

  def show
    @lessons = Lesson.includes(:user, :category).where users: {id: current_user.id},
      categories: {id: @category.id}
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
