class Read < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  attr_accessible :user_id, :post_id
  
  def self.by_user(user, date)
  	count(:all,
  		:conditions => ['created_at > ? and created_at < ? and user_id = ?', date.beginning_of_day, date.end_of_day, user.id])
  end

  def self.by_group(group, date)
  	joins(:post).count(:all,
  		:conditions => ['reads.created_at > ? and reads.created_at < ? and posts.group_id = ?', date.beginning_of_day, date.end_of_day, group.id])
  end

  def self.by_user_and_group(user, group, date)
  	joins(:post).count(:all,
  		:conditions => ['reads.created_at > ? and reads.created_at < ? and reads.user_id = ? and posts.group_id = ?', date.beginning_of_day, date.end_of_day, user.id, group.id])
  end
  
end
