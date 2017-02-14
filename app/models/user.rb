class User < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :activities, dependent: :destroy
  attr_accessor :remember_token, :reset_token
  before_save :downcase_email
  validates :name, presence: true, length: {maximum: Settings.maximum_name_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.maximum_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.minimum_password_length}, allow_nil: true
  default_scope {order "name ASC"}
  scope :search, -> q{where "name LIKE ? OR email LIKE ?", "%#{q}%", "%#{q}%"}

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
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_time.hours.ago
  end

  private
    def downcase_email
      self.email = email.downcase
    end
end
