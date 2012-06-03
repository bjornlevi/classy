require 'will_paginate/array'

class DashboardController < ApplicationController
  def home
  	@user = current_user if signed_in?
  	@blurts = current_user.blurts.build if signed_in?
  	@feed_items = current_user.feed.paginate(page: params[:page]) if signed_in?
  end

  def help
  end

  def about
  end
end
