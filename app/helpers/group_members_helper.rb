module GroupMembersHelper

	def is_member?(group, user=current_user)
		group.users.find(user)
	end
end
