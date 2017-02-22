class Activity < ApplicationRecord
  belongs_to :user
  enum action_type: [:start_lesson, :finish_lesson, :follow, :unfollow]
  validates :user_id, presence: true
  validates :action_id, presence: true

  def target_name
    case action_type
    when "start_lesson", "finish_lesson"
      target = Category.find_by id: action_id
    when "follow", "unfollow"
      target = User.find_by id: action_id
    end
    target ? target.name : String.new
  end

  def actor_name
    if user = User.find_by(id: user_id)
      user.name
    else
      String.new
    end
  end
end
