
class WinesController < ProductsController
  def initialize
    initialize_beverage_classes(:wine)
  end
end
