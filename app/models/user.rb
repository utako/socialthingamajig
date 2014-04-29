class User < ActiveRecord::Base
  attr_reader :password
  validates :email, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  has_many :friend_circles
  has_many :friends, through: :friend_circles, source: :members
  has_many :posts
  has_many :links, through: :posts

  # belongs to these friend circles
  has_many :memberships, class_name: "FriendCircleMembership"
  has_many :joined_circles, through: :memberships, source: :friend_circle

  def self.find_by_credentials(creds)
    user = User.find_by_email(creds[:user][:email])
    return user if user.is_password?(creds[:user][:password])
    nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.hex
    self.save!
    session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.hex
  end

end
