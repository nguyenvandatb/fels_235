class TestsController < ApplicationController
  before_action :logged_in_user, :load_lesson, only: :show

  def show
  end
end
