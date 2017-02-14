class UsersController < ApplicationController
  before_action :logged_in_user, only: :index
  before_action :load_user, only: :show

  def index
    @users = User.search(params[:q])
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      redirect_to root_url
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end
end
