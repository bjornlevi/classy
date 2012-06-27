class SearchController < ApplicationController
	before_filter :signed_in_user
	
	def index
		@search = "WHAT?!" if signed_in?
	end
end
