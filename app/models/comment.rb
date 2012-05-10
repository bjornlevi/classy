class Comment < ActiveRecord::Base
	attr_accessible :content, :post_id, :user_id

	belongs_to :post
	belongs_to :user

	default_scope order: 'comments.updated_at DESC'

end
