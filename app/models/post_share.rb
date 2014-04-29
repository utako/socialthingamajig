class PostShare < ActiveRecord::Base
  belongs_to :post
  belongs_to :friend_circle
  validates :post, :friend_circle, presence: true
end
