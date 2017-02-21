class FollowingController < ApplicationController
  before_action :logged_in_user, :load_user, only: :show

  def show
    @followers = @user.following.select :id, :name, :email
    @users = @followers.paginate page: params[:page],
      per_page: Settings.per_page
  end
end
