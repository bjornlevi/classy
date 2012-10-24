class Comment < ActiveRecord::Base
	attr_accessible :content, :post_id, :user_id

	belongs_to :post, touch: true, counter_cache: true
	belongs_to :user

	default_scope order: 'comments.updated_at ASC'

end
