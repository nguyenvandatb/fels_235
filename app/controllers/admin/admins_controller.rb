class Admin::AdminsController < ApplicationController
  layout "admin"

  def index
    @supports = Supports::AdminCount.new
  end
end
