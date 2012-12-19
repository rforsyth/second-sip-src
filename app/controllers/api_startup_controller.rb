
require 'api/api_configuration'

class ApiStartupController < ApiController
  
  def configuration
    configuration = Api::ApiConfiguration.new('http')
    #configuration.message_title = 'Got Yer Message'
    #configuration.message_detail = 'Hello Startup!'
    configuration.allow_access = 1
    render :json => configuration
  end
  
end