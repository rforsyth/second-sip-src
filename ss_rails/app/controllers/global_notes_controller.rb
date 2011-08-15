class GlobalNotesController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_notes_tabs
  
  # GET /:entity_type
  def browse
    @notes = @note_class.all
  end
  
  # GET /:entity_type/search
  def search
  end
  
  
end