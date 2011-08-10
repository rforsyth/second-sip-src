
class BreweriesController < ProducersController
  def initialize
    initialize_beverage_classes(:beer)
  end
end
