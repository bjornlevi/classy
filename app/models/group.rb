class Group < ActiveRecord::Base
  attr_accessible :description, :name, :status, :user_id

  has_many :group_members
  has_many :users, :through => :group_members

  has_many :group_applications
  has_many :applications, :through => :group_applications, :source => :user
  
  has_many :posts
end
