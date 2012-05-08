class Blurt < ActiveRecord::Base
	attr_accessible :content
	belongs_to :user

	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }

	default_scope order: 'blurts.created_at DESC'

	def self.from_friends(user)
		friend_ids = user.friend_ids.join(', ')
		where("user_id IN (?) OR user_id = ?", friend_ids, user)
	end

end
