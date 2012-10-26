module AdminHelper

	def is_admin?(user)
		Admin.exists?(user)
	end

	def admin_link(user)
		if is_admin?(user)
			link_to "Remove admin", admin_path(user), method: :put
		else
			link_to "Make admin", admin_path(user), method: :put
		end
	end
end
