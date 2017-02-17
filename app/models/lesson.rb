class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results
  has_many :words, through: :results
  accepts_nested_attributes_for :results, reject_if:
    proc {|result| result[:answer_id].blank?}
  attr_accessor :correct_count
  validate :has_word

  def add_lesson user, category
    words = []
    if category.words.count >= Settings.words_number
      words = category.words.sample Settings.words_number
    end
    words.each do |word|
      self.words << word
    end
    user.lessons << self
    category.lessons << self
  end

  def grade_lesson
    self.correct_count = 0
    self.results.each do |result|
      if result.answer_id == result.word.correct_answer
        result.is_correct = true
        self.correct_count += 1
      end
    end
    self.save
  end

  private
    def has_word
      errors.add(:cannot_create, I18n.t("cannot_create_lesson")) unless self.words.count > 0
    end
end
