
class ReferenceWineriesController < ReferenceProducersController
  before_filter :initialize_reference_wineries_tabs
  
  def initialize
    initialize_beverage_classes(:wine)
    super
  end
end
