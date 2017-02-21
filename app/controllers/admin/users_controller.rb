class Admin::UsersController < ApplicationController
  before_action :logged_in_user, :admin_user
  before_action :load_user, only: :destroy
  layout "admin"

  def index
    if params[:q].present? || params[:action_met].present?
      @users = User.select(:id, :name, :email, :created_at).search(params[:q])
        .send(params[:action_met])
        .paginate page: params[:page], per_page: Settings.per_page_user_admin
    else
      @users = User.select(:id, :name, :email, :created_at).paginate page: params[:page],
        per_page: Settings.per_page_user_admin
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".create_success"
    else
      flash[:error] = t ".create_error"
    end
    redirect_to action: :index
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:error] = t ".delete_error"
    end
    redirect_to :back
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
