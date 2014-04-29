class Post < ActiveRecord::Base
  validates :body, :user_id, presence: true
  has_many :links, inverse_of: :post
  has_many :shares, class_name: 'PostShare', foreign_key: :post_id,
    inverse_of: :post
  belongs_to :author, class_name: 'User', foreign_key: :user_id
end
