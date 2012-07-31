class AdminController < ApplicationController
	before_filter :signed_in_user
	
	def index
		@groups = Group.all
		@activities = current_user.activities
		@reads = current_user.reads
	end
end
