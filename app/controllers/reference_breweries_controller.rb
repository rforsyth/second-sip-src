
class ReferenceBreweriesController < ReferenceProducersController
  before_filter :initialize_reference_breweries_tabs
  
  def initialize
    initialize_beverage_classes(:beer)
    super
  end
end
