
class ApiWineNotesController < ApiNotesController
  def initialize
    initialize_beverage_classes(:wine)
    @current_entity_class = @note_class
    super
  end
end
