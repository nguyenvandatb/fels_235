class CategoriesController < ApplicationController
  before_action :load_category, only: :show
  before_action :logged_in_user, only: [:show, :index]

  def show
    @lessons = Lesson.includes(:user, :category).where users: {id: current_user.id},
      categories: {id: @category.id}
  end

  def index
    @categories = Category.includes(:words).search(params[:q]).order("name")
      .paginate page: params[:page],
        per_page: Settings.per_page_category
    @lesson = Lesson.new
  end

  private
    def load_category
      @category = Category.find_by id: params[:id]
      render_404 unless @category
    end
end
