
require 'api/query_results'

class ApiProductsController < ApiController
  
  def index
    products = find_beverage_by_owner_and_tags(@product_class,
                  current_taster, current_taster, params[:in], params[:ain])
    
    render :json => serialize_beverage_list(products)
  end
  
  def search
    products = search_beverage_by_owner(@product_class, params[:query],
                                          current_taster, current_taster)
                                          
    render :json => serialize_beverage_list(products)
  end
  
  
end
