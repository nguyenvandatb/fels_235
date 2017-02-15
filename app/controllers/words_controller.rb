class WordsController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @words = Word.includes(:answers).paginate page: params[:page],
      per_page: Settings.per_page_word
  end
end
