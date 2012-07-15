module GroupMembersHelper

	def is_member?(group, user=current_user)
		group.users.exists?(user)
	end

	def is_group_admin?(group)
		group.group_members.find_by_user_id(current_user.id).role == "admin"
	end

	def is_teacher?
		group = Group.find(Post.find(params[:id]).group_id)
		group.group_members.find_by_user_id(current_user.id).role == "admin" or is_group_admin?(group)
	end
end
