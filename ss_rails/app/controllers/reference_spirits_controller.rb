
class ReferenceSpiritsController < ReferenceProductsController
  before_filter :initialize_reference_spirits_tabs
  
  def initialize
    initialize_beverage_classes(:spirits)
    super
  end
end
