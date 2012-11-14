module PostHelper

	def preview(text, words)
		text = text.gsub("&nbsp;", " ")
		strip_tags(text).split(" ")[0..words].join(" ") + " ..."
	end

	def owns_tag?(user, post, tag_name)
	    tag = ActsAsTaggableOn::Tag.find_by_name(tag_name)
	    ActsAsTaggableOn::Tagging.find_by_tag_id_and_tagger_id_and_taggable_id_and_taggable_type(
	    	tag.id, current_user.id, post.id, "Post")
	end
end