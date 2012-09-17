class GroupMember < ActiveRecord::Base
  attr_accessible :group_id, :role, :user_id

  belongs_to :group
  belongs_to :user

  validates :role, :presence => :true
  validates :group_id, :uniqueness => {:scope => :user_id, :message => "Already a member of group"}

  def self.teacher?(user_id, group_id)
  	m = find_by_user_id_and_group_id(user_id, group_id)
  	if m.role == "teacher" or m.role == "admin"
  		true
  	else
  		false
  	end
  end
end
