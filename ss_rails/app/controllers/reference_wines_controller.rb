
class ReferenceWinesController < ReferenceProductsController
  def initialize
    initialize_beverage_classes(:wine)
  end
end