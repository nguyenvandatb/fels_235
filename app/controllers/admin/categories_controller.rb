class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :admin_user
  layout "admin"

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".create_success"
    end
    render :index
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :image
  end
end
