
class ApiBeerNotesController < ApiNotesController
  def initialize
    initialize_beverage_classes(:beer)
    super
  end
end
