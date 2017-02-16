class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :admin_user
  before_action :load_all_categories, only: [:new, :create, :index]
  layout "admin"

  def index
    if params[:category_id].present? || params[:q].present? ||
      params[:action_met].present?
       @words = Word.select(:id, :content, :created_at).includes(:answers)
                    .filter_category(params[:category_id])
                    .search(params[:q])
                    .send(params[:action_met], current_user.id)
                    .paginate page: params[:page],per_page: Settings.per_page_word_admin
    else
      @words = Word.select(:id, :content, :created_at)
                   .includes(:answers)
                   .paginate page: params[:page],per_page: Settings.per_page_word_admin
    end
  end

  def new
    @word = Word.new
  end

  def show
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

  def destroy
    if params[:id].present?
      @word = Word.where(id: params[:id])
      if @word
        @word.destroy_all
        respond_to do |format|
          format.json do
            render json: {
              status: I18n.t("status"),
              total_not_destroy: $total_not_destroy,
              total_destroy: $total_destroy
            }
          end
        end
        $total_not_destroy.clear
        $total_destroy.clear
      else
        respond_to do |format|
          format.json do
            render json: {
              status: I18n.t("status_fails")
            }
          end
        end
      end
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
