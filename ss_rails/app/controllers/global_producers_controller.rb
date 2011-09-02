class GlobalProducersController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_producers_tabs
  
  def browse
    @producers = @producer_class.all
  end
  
  def search
    @producers = @producer_class.search(params[:query])
  end
  
end