module ApplicationHelper
	before_filter :get_user_groups

	def get_user_groups
		puts "groups here"
	end

	def safe_html_output(content)
		s = sanitize content
		if s == ""
			content
		else
			s.html_safe
		end
	end

	def summarize(body, length)
		simple_format(truncate(body.gsub(/<\/?.*?>/,  ""), :length => length)).gsub(/<\/?.*?>/,  "")
	end
end
