class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password

  has_many :blurts, dependent: :destroy

  has_many :friendships
  has_many :friends, :through => :friendships, :dependent => :destroy
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user, :dependent => :destroy
  
  has_many :posts
  has_many :comments
  has_many :likes

  has_many :group_members
  has_many :groups, :through => :group_members

  has_many :group_applications
  has_many :applications, :through => :group_applications, :source => :group

  has_one :admin

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { within: 6..50 }, 
  	format: { with: VALID_EMAIL_REGEX },
  	uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    (Blurt.from_friends(self) + Post.from_friends(self)).sort_by(&:updated_at).reverse
  end

  def following?(other_user)
    friendships.find_by_friend_id(other_user.id)
  end

  def follow!(other_user)
    friendships.create!(friend_id: other_user.id)
  end

  def unfollow!(other_user)
    friendships.find_by_friend_id(other_user.id).destroy
  end

  def likes?(post)
    self.likes.find_by_post_id(post)
  end

private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
  
end
