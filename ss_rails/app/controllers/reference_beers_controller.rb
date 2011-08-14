
class ReferenceBeersController < ReferenceProductsController
  def initialize
    initialize_beverage_classes(:beer)
    super
  end
end