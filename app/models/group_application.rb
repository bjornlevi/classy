class GroupApplication < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :group
  belongs_to :user

  validates_uniqueness_of :group_id, :scope => :user_id
end
