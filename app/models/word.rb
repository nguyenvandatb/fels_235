class Word < ApplicationRecord
  belongs_to :category
  has_many :results
  has_many :answers

  scope :filter_category, ->category_id{where category_id: category_id if category_id.present?}
  scope :search, -> q{where "content LIKE ?", "%#{q}%"}
  scope :learned, ->user_id{where "id IN (SELECT word_id FROM answers WHERE is_correct = true
   AND id IN (SELECT word_id FROM results WHERE lesson_id IN
    (SELECT id FROM lessons WHERE user_id = #{user_id})))"}
  scope :not_learned, ->user_id{where "id NOT IN (SELECT word_id FROM answers WHERE is_correct = true
   AND id IN (SELECT word_id FROM results WHERE lesson_id IN
    (SELECT id FROM lessons WHERE user_id = #{user_id})))"}
  scope :all_words, ->user_id{}
  scope :alphabet, ->user_id{order("content")}
end
