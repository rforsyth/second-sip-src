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
    end
    
    def add_suggestion(label, value, id)
      @suggestions << Suggestion.new(label, value, id)
    end
    
  end
  
end