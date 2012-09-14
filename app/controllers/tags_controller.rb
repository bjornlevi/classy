class TagsController < ApplicationController
  	before_filter :signed_in_user
  	before_filter :correct_user, only: :destroy

	def show
		@response = Post.tagged_with(params[:id]).paginate(page: params[:page]).uniq
		render template: 'feeds/feeds'
	end

	def create
		p = Post.find(params[:post_id])
		@tag_name = params[:tag]
		new_tags = p.tags_from(current_user).append(@tag_name).join(',')
		current_user.tag(p, with: new_tags, on: :tags)
		@tag_response = "tag added"
	end

end
