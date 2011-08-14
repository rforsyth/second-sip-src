
class BeersController < ProductsController
  def initialize
    initialize_beverage_classes(:beer)
    super
  end
end