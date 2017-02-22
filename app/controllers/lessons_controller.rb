class LessonsController < ApplicationController
  before_action :load_category, :logged_in_user, only: :create
  before_action :load_lesson, only: :update

  def create
    lesson = Lesson.new user_id: current_user.id, category_id: @category.id
    if lesson.save
      flash[:success] = t ".create_success"
    else
      flash[:error] = t ".create_fail"
    end
      redirect_to :back
  end

  def update
    @lessons = current_user.lessons_in_category @lesson.category.id
    if params[:lesson]
      unless @lesson.update_attributes lesson_params
        flash[:danger] = t ".update_failed"
      end
    else
      flash[:danger] = t ".update_failed"
    end
  end

  private

  def load_lesson
    @lesson = Lesson.find_by id: params[:lesson][:lesson_id]
    render_404 unless @lesson
  end

  def lesson_params
    params.require(:lesson).permit :id, results_attributes: [:id, :answer_id]
  end
end
