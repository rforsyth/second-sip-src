class GlobalProducersController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_producers_tabs
  
  def browse
    @producers = find_global_beverage_by_tags(@producer_class, 
                  current_taster, params[:in], params[:ain])
    build_tag_filter(@producers)
    build_admin_tag_filter(@producers)
  end
  
  def search
    @producers = search_global_beverage(@producer_class, params[:query], current_taster)
  end
  
end