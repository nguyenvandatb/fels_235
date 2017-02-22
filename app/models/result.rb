class Result < ApplicationRecord
  belongs_to :lesson, required: false
  belongs_to :word
end
