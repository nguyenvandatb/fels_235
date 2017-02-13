class User < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_secure_password
end
