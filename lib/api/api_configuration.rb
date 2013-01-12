
module Api
	
  class ApiConfiguration
    attr_reader :protocol, :supports_ssl
    attr_accessor :message_title, :message_detail, :allow_access,
                  :use_www_subdomain_for_ssl
    
    def initialize(protocol, supports_ssl)
      @protocol = protocol
      @supports_ssl = supports_ssl
      @allow_access = 1
      @use_www_subdomain_for_ssl = 0
    end
  end
	
end