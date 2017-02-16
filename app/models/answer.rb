class Answer < ApplicationRecord
  belongs_to :word
  has_many :results
  belongs_to :word, required: false
end
