class FriendCircleMembership < ActiveRecord::Base
  validates :friend_circle, :friend, presence: true
  belongs_to :friend_circle, inverse_of: :memberships
  belongs_to :friend, class_name: "User", foreign_key: :user_id
  # validates :friend, uniqueness: { scope: :friend_circle }
end
