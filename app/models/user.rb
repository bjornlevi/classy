class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password

  acts_as_tagger

  has_many :blurts, dependent: :destroy

  has_many :friendships
  has_many :friends, :through => :friendships, :dependent => :destroy
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user, :dependent => :destroy
  
  has_many :posts
  has_many :comments
  has_many :likes
  has_many :features

  has_many :references

  has_many :group_members
  has_many :groups, :through => :group_members

  has_many :group_applications
  has_many :applications, :through => :group_applications, :source => :group

  has_many :activities
  has_many :reads

  has_one :admin

  has_one :profile, class_name: "UserProfile"

  before_save { |user| user.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { within: 6..50 }, 
  	format: { with: VALID_EMAIL_REGEX },
  	uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  before_create { generate_token(:auth_token) }

  def friend_feed
    (Blurt.from_friends(self) + Post.from_friends(self)).sort_by(&:updated_at).reverse
  end

  def recent_feed
    #TODO: limit by last visit date of user
    #TODO: limit to user groups
    (Blurt.all + Post.all).sort_by(&:updated_at).reverse
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

  def featured?(post)
    self.features.find_by_post_id(post)
  end

  def likes?(post)
    self.likes.find_by_post_id(post)
  end

  def name
    if self.profile
      self.profile.first_name
    else
      self.email.split('@')[0]
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset  
    generate_token(:password_reset_token)  
    self.password_reset_sent_at = Time.zone.now  
    save!
    UserMailer.password_reset(self).deliver  
  end  

end
