require 'gchart'

class AdminController < ApplicationController
	before_filter :signed_in_user
	
	def index
		@groups = Group.all
		@reads = Read.by_user(current_user, 3.weeks.ago)
		@read_range = (0..@reads.max).step(3).to_a
		@x_axis = []
		Date.today.downto(Date.today - 3.weeks) do |date|
			@x_axis << (@x_axis.length % 2 == 0 ? date.strftime("%b %d") : '')
		end
		@chart_url = Gchart.line(
			:title => "Participation by user: " + current_user.name,
			:size => "600x200", 
			:data => @reads, 
			:axis_with_labels => 'x,y',
            :axis_labels => [@x_axis.reverse, @read_range])
	end
end
