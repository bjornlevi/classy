module PostHelper

	def preview(text, words)
		text = text.gsub("&nbsp;", " ")
		strip_tags(text).split(" ")[0..words].join(" ") + " ..."
	end
end