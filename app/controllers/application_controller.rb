class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    render_404 unless @lesson
  end

  def logged_in_user
    unless logged_in?
      flash["danger"] = t "danger_err_login"
      redirect_to login_url
    end
  end

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end

  def load_category
    @category = Category.find_by id: params[:category_id]
    render_404 unless @category
  end
end
