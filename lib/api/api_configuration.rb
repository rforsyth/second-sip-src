
module Api
	
  class ApiConfiguration
    attr_reader :supports_ssl
    attr_accessor :message_title, :message_detail, :allow_access, :use_api_subdomain
    
    def initialize(supports_ssl)
      @supports_ssl = supports_ssl
      @allow_access = 1
      @use_api_subdomain = 0
    end
  end
	
end