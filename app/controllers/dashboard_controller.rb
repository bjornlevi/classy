require 'will_paginate/array'

class DashboardController < ApplicationController
  before_filter :signed_in_user

  def home
  	@user = current_user
  	@blurts = @user.blurts.build
  	@recents = group_filter(@user.recent_feed).paginate(page: params[:page])
  	@friends = group_filter(@user.friend_feed).paginate(page: params[:page], per_page: 10000)
    @featured = group_filter(Post.featured(@user)).paginate(page: params[:page], per_page: 10000) #TODO: limit to user groups
    @notifications = group_filter(@user.activity_feed).paginate(page: params[:page], per_page: 10000)
    @bookmarks = group_filter((@user.bookmarks.order(&:created_at).map {|bm| Post.find(bm.post_id)})).paginate(page: params[:page], per_page: 10000)
  	@all_tags = Post.tag_counts.order(:name)
    @group_tags = Group.tag_counts.order(:name)
    @user_tags = @user.owned_tags(:tags).order(:name)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def help
  end

  def about
  end

private

  def group_filter(feed)
    current_user_groups = current_user.groups.pluck(:group_id)
    feed.select do |i|
      if i.class == Post
        current_user_groups.include?(i.group_id)
      end
    end
  end

end
