class GlobalProductsController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_products_tabs
  
  def browse
    @products = find_global_beverage_by_tags(@product_class, current_taster, params[:in], params[:ain])
    build_tag_filter(@products)
    build_admin_tag_filter(@products)
  end
  
  def search
    @products = search_global_beverage(@product_class, params[:query], current_taster)
  end
  
end