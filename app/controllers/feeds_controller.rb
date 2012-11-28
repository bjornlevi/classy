class FeedsController < ApplicationController
	layout false
	respond_to :html
	before_filter :signed_in_user

	def friend_feed
		@response = current_user.friend_feed.paginate(page: params[:page])
		@user_groups = GroupMember.user_groups(current_user)
		render template: 'feeds/feeds'
	end

	def recent_feed
		@response = current_user.recent_feed.paginate(page: params[:page])
		@user_groups = GroupMember.user_groups(current_user)
		render template: 'feeds/feeds'
	end

	def featured_feed
		@response = current_user.featured_feed.paginate(page: params[:page])
		@user_groups = GroupMember.user_groups(current_user)
		render template: 'feeds/feeds'
	end
end