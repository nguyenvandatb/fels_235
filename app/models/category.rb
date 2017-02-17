class Category < ApplicationRecord
  has_many :lessons
  has_many :words
  scope :search, ->q{where "name LIKE ?", "%#{q}%"}
  mount_uploader :image, ImageUploader
  validate :image_size
  validates :name,  presence: true, length: {maximum: Settings.max_category_name_length}
  validates :description,  presence: true


  private
  def image_size
    if image.size > Settings.max_image_size.megabytes
      errors.add :image, t("image_size_message")
    end
  end
end
