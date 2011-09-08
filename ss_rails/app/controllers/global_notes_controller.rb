class GlobalNotesController < ApplicationController
  before_filter :initialize_beverage_classes_from_entity_type_param
	before_filter :initialize_global_notes_tabs
  
  def browse
    @notes = find_global_beverage_by_tags(@note_class, current_taster, params[:in], params[:ain])
    build_tag_filter(@notes)
    build_admin_tag_filter(@notes)
  end
  
  def search
    @notes = @note_class.search(params[:query])
  end
  
end