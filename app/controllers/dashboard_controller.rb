require 'will_paginate/array'

class DashboardController < ApplicationController
  def home
  	@user = current_user if signed_in?
  	@blurts = current_user.blurts.build if signed_in?
  	@recents = current_user.recent_feed.paginate(page: params[:page]) if signed_in?
  	@friends = current_user.friend_feed.paginate(page: params[:page]) if signed_in?
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
