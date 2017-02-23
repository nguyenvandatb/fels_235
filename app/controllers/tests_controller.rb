class TestsController < ApplicationController
  before_action :logged_in_user, :load_category, :load_lesson, only: :show

  def show
    @lessons = Lesson.includes(:user, :category).where users: {id: current_user.id},
      categories: {id: @category.id}
  end
end
