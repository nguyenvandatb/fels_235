class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results
  has_many :words, through: :results

  accepts_nested_attributes_for :results, reject_if:
    proc {|result| result[:answer_id].blank?}
  validate :has_word
  before_create :add_words
  after_create :start_activity
  before_update :grade_lesson
  after_update :finish_activity

  private

  def add_words
    words = category.words.order("RANDOM()").limit(Settings.words_number)
    self.words << words
  end

  def has_word
    if category.words.count < Settings.words_number
      errors.add :cannot_create, I18n.t("cannot_create_lesson")
      throw :abort
    end
  end

  def grade_lesson
    self.correct_count = 0
    self.results.each do |result|
      if result.answer_id == result.word.correct_answer
        result.is_correct = true
        self.correct_count += 1
      end
    end
    self.is_finished = true
  end

  def start_activity
    User.create_activity self.user_id, :start_lesson, self.category_id
  end

  def finish_activity
    User.create_activity self.user_id, :finish_lesson, self.category_id
  end
end
