class Word < ApplicationRecord
  belongs_to :category
  has_many :results
  has_many :answers
  validates :content, presence: true

  accepts_nested_attributes_for :answers,
    reject_if: ->answer{answer[:content].blank?},
    allow_destroy: true
  scope :filter_category, ->category_id{where category_id: category_id if category_id.present?}
  scope :search, ->q{where "content LIKE ?", "%#{q}%"}
  scope :learned, ->user_id{where "id IN (SELECT word_id FROM answers WHERE is_correct = true
   AND id IN (SELECT word_id FROM results WHERE lesson_id IN
    (SELECT id FROM lessons WHERE user_id = #{user_id})))"}
  scope :not_learned, ->user_id{where "id NOT IN (SELECT word_id FROM answers WHERE is_correct = true
   AND id IN (SELECT word_id FROM results WHERE lesson_id IN
    (SELECT id FROM lessons WHERE user_id = #{user_id})))"}
  scope :all_words, ->user_id{}
  scope :alphabet, ->user_id{order("content")}
  scope :alphabetcba, ->user_id{order("content DESC")}
  scope :date, ->user_id{order("created_at")}
  before_destroy :check_for_results
  $total_not_destroy = []
  $total_destroy = []
  def correct_answer
    self.answers.each do |answer|
      if answer.is_correct
        return answer.id
      end
    end
    -1
  end

  def correct_content
    self.answers.each do |answer|
      if answer.is_correct
        return answer.content
      end
    end
    ""
  end

  def check_answer_count
    if self.answers.size <= Settings.number_questions_validate_min ||
      self.answers.size >= Settings.number_questions_validate_max
      errors.add :items, I18n.t("validate_answer_min")
    end
  end

  def check_answer_is_correct
    if self.answers.size >= Settings.number_questions_validate_min &&
      self.answers.size <= Settings.number_questions_validate_max
      @correct = self.answers.select{|answer| answer.is_correct == true}
      errors.add :items, I18n.t("validate_answer_correct") unless @correct.size ==
        Settings.number_questions_validate_equal
    end
  end

  def check_answer_equal
    if self.answers.size >= Settings.number_questions_validate_min &&
      self.answers.size <= Settings.number_questions_validate_max
      @duplicate = self.answers.detect{|answer| self.answers.count(answer) >
        Settings.number_questions_validate_equal}
      errors.add :items, I18n.t("validate_answer_same") unless @duplicate.nil?
    end
  end

  def check_for_results
    if results.any?
      errors.add :base, I18n.t("validate_results_exits")
      $total_not_destroy.push(self.content)
      throw :abort
    else
      $total_destroy.push(self.content)
    end
  end
end
