class Read < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  attr_accessible :user_id, :post_id
  
  scope :created, order('created_at asc')

  #Read.by_user(User.first, Post.first.created_at, Post.last.created_at)
  def self.by_user(user, first_date, last_date)
  	actions_per_day = where(created_at: first_date.beginning_of_day..last_date.end_of_day, user_id: user.id).
  		group('date(created_at)').
  		select('created_at, count(created_at) as nr_created')
  		(first_date.to_date..last_date.to_date).map do |date|
  			action = actions_per_day.detect { |a| a.created_at.to_date == date}
  			action && action.nr_created || 0
  		end
  end

  def self.by_post(post, first_date, last_date)
    actions_per_day = where(created_at: first_date.beginning_of_day..last_date.end_of_day, post_id: post.id).
      group('date(created_at)').
      select('created_at, count(created_at) as nr_created')
      (first_date.to_date..last_date.to_date).map do |date|
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
