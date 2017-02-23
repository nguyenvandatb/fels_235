class Admin::AdminsController < ApplicationController
  before_action :logged_in_user, :admin_user
  layout "admin"

  def index
    @supports = Supports::AdminCount.new
  end
end
