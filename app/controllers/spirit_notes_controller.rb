
class SpiritNotesController < NotesController
  def initialize
    initialize_beverage_classes(:spirits)
    super
  end
end
