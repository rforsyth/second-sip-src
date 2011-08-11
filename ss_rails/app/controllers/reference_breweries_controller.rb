
class ReferenceBreweriesController < ReferenceProducersController
  def initialize
    initialize_beverage_classes(:beer)
  end
end