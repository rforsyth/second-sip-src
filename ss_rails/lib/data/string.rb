
class String
  
  def canonicalize
		self.canonicalize_helper(false)
  end
  
  def slugify
    self.canonicalize_helper(true).gsub(/[ ]/, '-')
  end
  
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end

	def canonicalize_helper(include_spaces)
    # first convert accented characters to their standard equivalent
    # then remove any non-alphanumeric characters
		allowed_chars = include_spaces ? /[^a-z0-9 ]/ : /[^a-z0-9]/
    canonical = self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s.gsub(allowed_chars,'')
		# then remove trailing and leading whitespace and collapse multiple internal spaces to a single space
		canonical =  canonical.strip.squeeze(' ') if include_spaces
		return canonical
	end
  
  def slug_to_canonical
    self.gsub(/[-]/, '')
  end

	def tagify
		tag = self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
		tag = tag.gsub(/[^a-z0-9\- ]/,'')
		tag = tag.strip.gsub(' ', '-').squeeze('-')
		tag = tag[0..39] if tag.length > 40
		return tag
    #self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s.gsub(/[^a-z0-9_-]/,'')
	end
  
end
