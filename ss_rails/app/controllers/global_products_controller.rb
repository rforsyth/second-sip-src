class GlobalProductsController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_products_tabs
  
  def browse
    @products = polymorphic_find_by_tags(@product_class, params[:in], params[:ain])
    build_tag_filter(@products)
    build_admin_tag_filter(@products)
  end
  
  def search
    @products = @product_class.search(params[:query])
  end
  
end