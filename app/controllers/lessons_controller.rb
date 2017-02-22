class LessonsController < ApplicationController
  before_action :load_category, :logged_in_user, only: :create

  def create
    lesson = Lesson.new user_id: current_user.id, category_id: @category.id, is_finished: false
    lesson.add_lesson @category
    redirect_to :back
  end

  private
    def load_category
      @category = Category.find_by id: params[:category_id]
      render_404 unless @category
    end
end
