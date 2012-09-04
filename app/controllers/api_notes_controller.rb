
require 'api/query_results'

class ApiNotesController < ApiController
  
  def index
    notes = find_beverage_by_owner_and_tags(@note_class,
               current_taster, current_taster, params[:in], params[:ain])
               
    render :json => serialize_beverage_list(notes)
  end
  
  def search
    notes = search_beverage_by_owner(@note_class, params[:query],
                                          current_taster, current_taster)
                                          
    render :json => serialize_beverage_list(notes)
  end
  
  
end
