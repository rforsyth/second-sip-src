class GlobalProductsController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_products_tabs
  
  # GET /:entity_type
  def browse
    @products = @product_class.all
  end
  
  # GET /:entity_type/search
  def search
  end
  
end