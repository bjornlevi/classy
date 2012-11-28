class Bookmark < ActiveRecord::Base
  attr_accessible :post_id, :user_id

  belongs_to :post
  belongs_to :user

  scope :created, order('created_at asc')

  validates :user_id, presence: true
  validates :post_id, presence: true
end
