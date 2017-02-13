class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @categories = Category.all
    end
  end

  def about
  end

  def help
  end
end
