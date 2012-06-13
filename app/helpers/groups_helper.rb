module GroupsHelper

	def user_groups
		if signed_in?
			@header_groups = current_user.groups || ["Classy"]
			@current_group = current_user.groups.first
		else
			@current_group = ["Classy"]
		end
	end

	def user_applications(user)
		User.find(user).applications
	end

	def group_user(group)
		Group.find(group).users
	end

	def group_applications(group)
		Group.find(group).applications 
	end

end
