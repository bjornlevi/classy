require 'gchart'

class AdminController < ApplicationController
	before_filter :signed_in_user
	
	def index
		@groups = Group.all
	end
end
