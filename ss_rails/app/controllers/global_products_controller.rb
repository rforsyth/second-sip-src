class GlobalProductsController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_products_tabs
  
  def browse
    @products = @product_class.all
  end
  
  def search
    @products = @product_class.search(params[:query])
  end
  
end