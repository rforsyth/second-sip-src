
class ReferenceDistilleriesController < ReferenceProducersController
  before_filter :initialize_reference_distilleries_tabs
  
  def initialize
    initialize_beverage_classes(:spirits)
    super
  end
end
