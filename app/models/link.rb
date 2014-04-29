class Link < ActiveRecord::Base
  belongs_to :post, inverse_of: :links
  validates :title, :url, :post, presence: true
end
