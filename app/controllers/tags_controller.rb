class TagsController < ApplicationController
  	before_filter :signed_in_user
  	before_filter :correct_user, only: :destroy

	def show
		@response = Post.tagged_with(params[:id]).paginate(page: params[:page]).uniq
		@user_groups = GroupMember.user_groups(current_user)
    	@group_tags = @user_groups.map{|g|g.tag_counts.order(:name)}.flatten
		render template: 'feeds/feeds'
	end

end
