class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end

  def logged_in_user
    unless logged_in?
      flash["danger"] = t "danger_err_login"
      redirect_to login_url
    end
  end
end
