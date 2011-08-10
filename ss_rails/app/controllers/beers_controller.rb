
class BeersController < ProductsController
  def initialize
    initialize_beverage_classes(:beer)
  end
end