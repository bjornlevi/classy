module GroupApplicationsHelper

	def has_application?(user=current_user)
		GroupApplication.find_by_user_id(user)
	end

end
