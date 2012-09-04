
class ApiSpiritNotesController < ApiNotesController
  def initialize
    initialize_beverage_classes(:spirits)
    super
  end
end
