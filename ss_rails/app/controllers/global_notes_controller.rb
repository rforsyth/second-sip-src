class GlobalNotesController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_notes_tabs
  
  def browse
    @notes = @note_class.all
  end
  
  def search
    @notes = @note_class.search(params[:query])
  end
  
end