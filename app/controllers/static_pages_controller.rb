class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @activities = current_user.feed.paginate page: params[:page],
        per_page: Settings.per_page_activities
    end
  end

  def about
  end

  def help
  end
end
