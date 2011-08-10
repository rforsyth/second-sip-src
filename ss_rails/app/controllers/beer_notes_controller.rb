
class BeerNotesController < NotesController
  def initialize
    initialize_beverage_classes(:beer)
  end
end