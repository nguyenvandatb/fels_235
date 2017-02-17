class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :admin_user
  before_action :load_all_categories, only: [:new, :create]
  layout "admin"

  def new
    @word = Word.new
  end

  def create
    @word = Word.new word_params
    if @word.save
      flash[:success] = t ".success"
      redirect_to admin_root_url
    else
      render :new
    end
  end

  private
  def load_all_categories
    @categories = Category.all
  end

  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end
end
