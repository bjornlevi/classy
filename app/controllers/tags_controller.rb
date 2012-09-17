class TagsController < ApplicationController
  	before_filter :signed_in_user
  	before_filter :correct_user, only: :destroy

	def show
		@response = Post.tagged_with(params[:id]).paginate(page: params[:page]).uniq
		render template: 'feeds/feeds'
	end

end
