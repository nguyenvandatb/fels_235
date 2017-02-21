class Answer < ApplicationRecord
  has_many :results
  belongs_to :word, required: false
end
