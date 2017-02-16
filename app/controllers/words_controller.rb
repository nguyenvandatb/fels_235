class WordsController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @categories = Category.all
    if params[:category_id].present? || params[:q].present? ||
        params[:action_met].present?
      @words = Word.includes(:answers)
                   .filter_category(params[:category_id])
                   .search(params[:q])
                   .send(params[:action_met], current_user.id)
                   .paginate page: params[:page], per_page: Settings.per_page_word
    else
      @words = Word.includes(:answers).paginate page: params[:page],
        per_page: Settings.per_page_word
    end
  end
end
