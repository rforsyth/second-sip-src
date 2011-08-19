
class ReferenceWinesController < ReferenceProductsController
  before_filter :initialize_reference_wines_tabs
  
  def initialize
    initialize_beverage_classes(:wine)
    super
  end
end
