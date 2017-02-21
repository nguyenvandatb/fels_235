class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token, :reset_token
  has_many :lessons, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  before_save :downcase_email
  validates :name, presence: true, length: {maximum: Settings.maximum_name_length}
  validates :email, presence: true, length: {maximum: Settings.maximum_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.minimum_password_length}, allow_nil: true
  scope :search, ->q{where "name LIKE ? OR email LIKE ?", "%#{q}%", "%#{q}%"}
  scope :alphabet, ->{order("name")}
  scope :alphabetcba, ->{order("name DESC")}
  scope :date, ->{order("created_at")}

  def forget
    update_attribute :remember_digest, nil
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_time.hours.ago
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
      WHERE  follower_id = :user_id"
    Activity.where("user_id IN (#{following_ids})
      OR user_id = :user_id", user_id: id).order(created_at: :desc)
  end

  def self.create_activity user_id, action_type, action_id
    Activity.create user_id: user_id, action_type: action_type, action_id: action_id
  end

  private
    def downcase_email
      self.email = email.downcase
    end
end
