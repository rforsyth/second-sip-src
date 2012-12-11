

class ApiWinesController < ApiProductsController
  def initialize
    initialize_beverage_classes(:wine)
    @current_entity_class = @product_class
    super
  end
end

