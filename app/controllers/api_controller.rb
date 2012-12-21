
require 'api/query_results'

class ApiController < ApplicationController
  
  def build_validation_error_response(type, title, explanation, entity)
    results = Api::ErrorResults.new(type, title, explanation)
    results.add_model_validation_messages(entity)
    return results
  end
  
  def render_duplicate_entity_json_error(operation, entity, name)
    response = Api::ErrorResults.new(operation, 'Unable to Save', 
          "A " + entity.class.name + " already exists with the name \'" + name + "\'")
    render :json => response, :status => 500
  end
  
  def render_data_validation_json_error(operation, entity)
    response = build_validation_error_response(operation, 'Unable to Save', 
      'These fields cannot be saved:' , entity)
    render :json => response, :status => 500
  end
  
  def render_login_json_error(operation, entity)
    response = build_validation_error_response(operation, 'Unable to Log In', 
      'Credentials were not recognized.  Please try again.' , entity)
    render :json => response, :status => 500
  end
  
  def render_unexpected_json_error(exception)
    log_exception(exception)
    response = Api::ErrorResults.new(:fatal_exception, 'Unexpected Error', 
      'We were unable to complete the operation due to an unexpected server error. Sorry for any inconvenience')
    render :json => response, :status => 500
  end
  
end