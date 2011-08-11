
class ReferenceWineriesController < ReferenceProducersController
  def initialize
    initialize_beverage_classes(:wine)
  end
end