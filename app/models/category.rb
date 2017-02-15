class Category < ApplicationRecord
  has_many :lessons
  has_many :words
  scope :search, -> q{where "name LIKE ?", "%#{q}%"}
end
