
class ReferenceBeersController < ReferenceProductsController
	
  before_filter :initialize_reference_beers_tabs
  
  def initialize
    initialize_beverage_classes(:beer)
    super
  end
end
