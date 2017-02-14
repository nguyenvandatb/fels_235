class LessonsController < ApplicationController
  before_action :load_category, :logged_in_user, only: :create

  def create
    lesson = Lesson.new is_finished: false
    lesson.add_lesson current_user, @category
    unless lesson.words.count > 0
      flash[:error] = t ".err_message"
    end
    redirect_to :back
  end

  private
    def load_category
      @category = Category.find_by id: params[:category_id]
      render_404 unless @category
    end
end
