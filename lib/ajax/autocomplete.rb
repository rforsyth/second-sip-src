#require 'json'

module Ajax
	
	class Suggestion
		attr_reader :label, :value, :id
		
		def initialize(label, value, id)
			@label = label
			@value = value
			@id = id
		end
	end
  
  class Autocomplete
    attr_reader :query, :suggestions
    
    def initialize(query)
      @query = query
      @suggestions = []
      @included_names = {}
    end
    
    def includes_value?(name)
      @included_names.has_key?(name.canonicalize)
    end
    
    def add_suggestion(label, value, id)
      @suggestions << Suggestion.new(label, value, id)
      @included_names[value.canonicalize] = value
    end
    
  end
  
end