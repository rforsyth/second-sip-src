
class ReferenceBeersController < ReferenceProductsController
  def initialize
    initialize_beverage_classes(:beer)
  end
end