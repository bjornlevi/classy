class Group < ActiveRecord::Base
  attr_accessible :description, :name, :status, :user_id

  has_many :group_members
  has_many :users, :through => :group_members

  has_many :group_applications
  has_many :applications, :through => :group_applications, :source => :user
  
  has_many :posts

  validates :name, presence: true, length: { within: 3..50 }, 
  	uniqueness: { case_sensitive: false }

	def is_closed?
		self.status == "closed"
	end

  def is_open?
    self.status == "open"
  end

  def group_admin?(user)
    GroupMember.find_by_group_id_and_user_id(self.id, user.id).role == 'admin'
  end

end
