
class WineriesController < ProducersController
  def initialize
    initialize_beverage_classes(:wine)
    super
  end
end
