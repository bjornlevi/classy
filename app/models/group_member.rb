class GroupMember < ActiveRecord::Base
  attr_accessible :group_id, :role, :user_id

  belongs_to :group
  belongs_to :user

  validates :role, :presence => :true
  validates :group_id, :uniqueness => {:scope => :user_id, :message => "Already a member of group"}
end
