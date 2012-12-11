
module Api
	
  class ErrorResults
    attr_reader :type, :title, :explanation, :detail_messages
    
    def initialize(type, title, explanation)
      @type = type
      @title = title
      @explanation = explanation
      @detail_messages = []
    end
    
    def add_message(message)
      @detail_messages << message
    end
    
    def add_model_validation_messages(model)
      model.errors.full_messages.each do |msg|
        add_message(msg)
      end
    end
    
  end
	
end