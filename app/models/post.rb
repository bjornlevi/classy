class Post < ActiveRecord::Base
	
	attr_accessible :content, :title, :user_id

	belongs_to :user

	validates :user_id, presence: true
	validates :content, presence: true
	validates :title, presence: true

	default_scope order: 'posts.created_at DESC'

	def self.from_friends(user)
		friend_ids = user.friend_ids.join(', ')
		where("user_id IN (?) OR user_id = ?", friend_ids, user)
	end

end
