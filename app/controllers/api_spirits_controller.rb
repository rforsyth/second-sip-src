
class ApiSpiritsController < ApiProductsController
  def initialize
    initialize_beverage_classes(:spirits)
    @current_entity_class = @product_class
    super
  end
end
