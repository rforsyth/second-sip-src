
class ReferenceSpiritsController < ReferenceProductsController
  def initialize
    initialize_beverage_classes(:spirits)
  end
end