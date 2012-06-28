module AdminHelper

	def is_admin?(user)
		Admin.exists?(user)
	end
end
