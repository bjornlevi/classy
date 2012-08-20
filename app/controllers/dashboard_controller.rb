require 'will_paginate/array'

class DashboardController < ApplicationController
  before_filter :signed_in_user

  def home
  	@user = current_user
  	@blurts = current_user.blurts.build
  	@recents = current_user.recent_feed.paginate(page: params[:page])
  	@friends = current_user.friend_feed.paginate(page: params[:page])
    @featured = Post.featured(current_user).paginate(page: params[:page]) #TODO: limit to user groups
  	@tags = Post.tag_counts.order(:name)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def help
  end

  def about
  end
end
