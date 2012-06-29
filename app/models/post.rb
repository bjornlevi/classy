class Post < ActiveRecord::Base
	
	attr_accessible :content, :title, :user_id

	acts_as_taggable

	belongs_to :user
	has_many :comments
	has_many :likes
	belongs_to :group

	validates :user_id, presence: true
	validates :content, presence: true
	validates :title, presence: true
	validates :group_id, presence: true

	default_scope order: 'posts.updated_at DESC'

	def self.from_friends(user)
		friend_ids = user.friend_ids.join(', ')
		where("user_id IN (?) OR user_id = ?", friend_ids, user)
	end

	def add_like(user)
		likes.create!(user_id: user)
	end

	def destroy_like(user)
		likes.find_by_user_id(user.id).destroy
	end

end
