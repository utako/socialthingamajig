class FriendCircle < ActiveRecord::Base
  validates :name, :user_id, presence: true
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :memberships, class_name: 'FriendCircleMembership', foreign_key: :friend_circle_id, inverse_of: :friend_circle
  has_many :members, through: :memberships, source: :friend
  has_many :shares, class_name: 'PostShare'
  has_many :posts, through: :shares

end
