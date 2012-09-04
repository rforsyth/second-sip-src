
module Api
	
  class QueryResults
    attr_reader :type, :results
    
    def initialize(type)
      @type = type
      @results = []
    end
    
    
    def add(result)
      @results << result
    end
    
  end
	
end