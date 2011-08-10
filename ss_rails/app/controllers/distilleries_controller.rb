
class DistilleriesController < ProducersController
  def initialize
    initialize_beverage_classes(:spirits)
  end
end
