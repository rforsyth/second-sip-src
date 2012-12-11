
class ApiBreweriesController < ApiProducersController
  def initialize
    initialize_beverage_classes(:beer)
    @current_entity_class = @producer_class
    super
  end
end
