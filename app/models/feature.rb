class Feature < ActiveRecord::Base
  attr_accessible :post_id, :user_id

  belongs_to :post, :touch => true, counter_cache: true
  belongs_to :user

  validates :user_id, presence: true
  validates :post_id, presence: true
end