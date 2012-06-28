module GroupApplicationsHelper

	def has_application?(group, user=current_user)
		GroupApplication.exists?(group_id: group, user_id: user)
	end

end
