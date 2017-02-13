class UsersController < ApplicationController
  def show
    load_user
  end

  private
    def load_user
      @user = User.find_by id: params[:id]
      render_404 unless @user
    end
end
