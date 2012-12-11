
class ApiBeersController < ApiProductsController
  def initialize
    initialize_beverage_classes(:beer)
    @current_entity_class = @product_class
    super
  end
end
