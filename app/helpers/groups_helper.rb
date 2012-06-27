module GroupsHelper

	def user_groups
		if signed_in?
			@header_groups = current_user.groups
			@current_group = current_user.groups.first #change to user preference
		else
			@header_groups = []
			@current_group = nil
		end
	end

	def can_post_to?(group)
		Group.exists?(group)
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

	def member?(user)

	end

end
