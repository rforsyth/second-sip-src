
require 'api/query_results'

class ApiController < ApplicationController
  
  API_MAX_BEVERAGE_RESULTS = 50
  
  def serialize_beverage_list(beverages)
    
    results = Api::QueryResults.new(:newest)
    
    beverages.each do |beverage|
	    results.add(beverage.api_copy)
    end
    results
  end
  
  
  
end