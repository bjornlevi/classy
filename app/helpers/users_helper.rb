module UsersHelper

	def gravatar_for(user, size=128)
	    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
	    image_tag(gravatar_url, alt: user.email, class: "gravatar")
	end

end
