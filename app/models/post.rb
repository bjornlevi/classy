class Post < ActiveRecord::Base
	
	attr_accessible :content, :title, :user_id, :group_id

	acts_as_taggable

	belongs_to :user
	belongs_to :group

	has_many :comments
	has_many :likes
	has_many :features
	has_many :references
	has_many :reads

	validates :user_id, presence: true
	validates :content, presence: true
	validates :title, presence: true
	validates :group_id, presence: true

	default_scope order: 'posts.updated_at DESC'
	scope :created, reorder('created_at asc')

	def self.from_friends(user)
		friend_ids = user.friend_ids
		find_all_by_user_id(friend_ids)
	end

	def self.featured(user)
		#(Post.joins(:features) + Post.joins(:likes) + Post.joins(:comments).group('posts.id')).uniq.sort_by(&:updated_at).reverse #TODO: limit to user groups
		(Post.joins(:features) + Post.joins(:likes)).uniq.sort_by(&:updated_at).reverse #TODO: limit to user groups
	end

	def add_like(user)
		likes.create!(user_id: user.id)
	end

	def destroy_like(user)
		likes.find_by_user_id(user.id).destroy
	end

	def add_feature(user)
		features.create!(user_id: user.id)
	end

	def destroy_feature(user)
		features.find_by_user_id(user.id).destroy
	end

	def add_reference(user)
		reference.create!(user_id: user.id)
	end

	def destroy_reference(user)
		reference.find_by_user_id(user.id).destroy
	end
end
