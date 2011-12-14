

class Float

	def pretty_print
		if self == self.to_i
			return self.to_i.to_s
		end
		return self.to_s
	end
	
end
