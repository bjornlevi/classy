class Reference < ActiveRecord::Base
	attr_accessible :url_type, :user_id, :post_id, :url

	belongs_to :user
	belongs_to :post

	validates :user_id, presence: true
	validates :url_type, presence: true
	validates :url, presence: true
	validates :post_id, presence: true

end
