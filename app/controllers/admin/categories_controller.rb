class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :admin_user
  before_action :load_category, only: [:edit, :destroy]
  layout "admin"

  def index
    if params[:q].present? || params[:action_met].present?
      @categories = Category.includes(:words).search(params[:q])
        .send(params[:action_met])
        .paginate page: params[:page], per_page: Settings.per_page_category_admin
    else
      @categories = Category.includes(:words).paginate page: params[:page],
        per_page: Settings.per_page_category_admin
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".create_success"
    else
      flash[:error] = t ".create_error"
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    unless @category.words.any?
      if @category.destroy
        flash[:success] = t ".delete_success"
      else
        flash[:error] = t ".delete_error"
      end
    else
      flash[:error] = t ".delete_error"
    end
    redirect_to :back
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :image
  end

  def load_category
    @category = Category.find_by id: params[:id]
    render_404 unless @category
  end
end
