class TestsController < ApplicationController
  before_action :logged_in_user, :load_category, :load_lesson, only: :show

  def show
    @lessons = current_user.lessons_in_category params[:category_id]
  end
end
