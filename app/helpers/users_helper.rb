module UsersHelper

	def gravatar_for(user, size=128)
	    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
	    image_tag(gravatar_url, alt: user.email, class: "gravatar")
	end

	def is_admin?(user=current_user)
		if signed_in? then
			Admin.find_by_user_id(user)
		else
			return false
		end
	end


end
