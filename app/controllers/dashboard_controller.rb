class DashboardController < ApplicationController
  def home
  	@blurt = current_user.blurts.build if signed_in?
  	@feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end
end
