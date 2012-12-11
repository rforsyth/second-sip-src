

class ApiWineriesController < ApiProducersController
  def initialize
    initialize_beverage_classes(:wine)
    @current_entity_class = @producer_class
    super
  end
end

