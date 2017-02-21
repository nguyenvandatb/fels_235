class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  after_save :follow_activity
  before_destroy :unfollow_activity

  private
  def follow_activity
    User.create_activity follower_id, :follow, followed_id
  end

  def unfollow_activity
    User.create_activity follower_id, :unfollow, followed_id
  end
end
