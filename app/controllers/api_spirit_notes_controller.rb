
class ApiSpiritNotesController < ApiNotesController
  def initialize
    initialize_beverage_classes(:spirits)
    @current_entity_class = @note_class
    super
  end
end
