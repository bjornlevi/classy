require 'will_paginate/array'

class SearchController < ApplicationController
	before_filter :signed_in_user
	
	def index
		#TODO: restrict to user groups
		@response = Post.find(:all, :conditions => ['content LIKE :search OR title LIKE :search', {:search => "%#{params[:search]}%"}]).paginate(page: params[:page], per_page: 10000)
		render template: 'feeds/feeds'
	end
end
