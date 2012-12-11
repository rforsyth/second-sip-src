
class ApiBeerNotesController < ApiNotesController
  def initialize
    initialize_beverage_classes(:beer)
    @current_entity_class = @note_class
    super
  end
end
