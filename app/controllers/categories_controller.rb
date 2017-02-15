class CategoriesController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @categories = Category.includes(:words).search(params[:q]).order("name")
      .paginate page: params[:page],
        per_page: Settings.per_page_category
    @lesson = Lesson.new
  end
end
