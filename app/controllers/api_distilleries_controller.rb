
class ApiDistilleriesController < ApiProducersController
  def initialize
    initialize_beverage_classes(:spirits)
    @current_entity_class = @producer_class
    super
  end
end
