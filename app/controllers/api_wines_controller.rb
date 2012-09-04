

class ApiWinesController < ApiProductsController
  def initialize
    initialize_beverage_classes(:wine)
    super
  end
end

