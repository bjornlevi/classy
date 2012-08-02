class Read < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  attr_accessible :user_id, :post_id
  
  #Read.by_user(User.first, 5.days.ago)
  def self.by_user(user, date)
  	actions_per_day = where(created_at: date.beginning_of_day..Time.zone.now.end_of_day, user_id: user.id).
  		group('date(created_at)').
  		select('created_at, count(created_at) as nr_created')
  		(date.to_date..Date.today).map do |date|
  			action = actions_per_day.detect { |a| a.created_at.to_date == date}
  			action && action.nr_created || 0
  		end
  end

  def self.by_group(group, date)
  	actions_per_day = joins(:post).where('reads.created_at' => date.beginning_of_day..Time.zone.now.end_of_day,
  		'posts.group_id' => group.id).
  		group('date(reads.created_at)').
  		select('reads.created_at, count(reads.created_at) as nr_created')
  		(date.to_date..Date.today).map do |date|
  			action = actions_per_day.detect { |a| a.created_at.to_date == date}
  			action && action.nr_created || 0
  		end  		
  end

  def self.by_user_and_group(user, group, date)
  	actions_per_day = joins(:post).where('reads.created_at' => date.beginning_of_day..Time.zone.now.end_of_day,
  		'posts.group_id' => group.id, 'reads.user_id' => user.id).
  		group('date(reads.created_at)').
  		select('reads.created_at, count(reads.created_at) as nr_created')
  		(date.to_date..Date.today).map do |date|
  			action = actions_per_day.detect { |a| a.created_at.to_date == date}
  			action && action.nr_created || 0
  		end 
  end
  
end
