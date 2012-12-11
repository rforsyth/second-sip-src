
require 'api/query_results'

class ApiNotesController < ApiEntitiesController
  

  def show
    note = @note_class.find(params[:id])
    api_note = build_full_api_note(note)
    render :json => api_note
  end
  
  def create
    note = @note_class.new(params['note'])
    set_product_from_params(note)
    note.tasted_at = Time.now if !note.tasted_at.present?
    note.set_occasion(params[:occasion_name], current_taster)
    
    if note.save
      note.update_tags params[:tags]
      # need to run a query to pull new lookups
      full_note = @note_class.find(note.id)
      render :json => build_full_api_note(full_note)
    else
      render_data_validation_json_error(:create, note)
    end
  end

  def update
    note = @note_class.find(params[:id])
    set_product_from_params(note)
    note.update_tags params[:tags]
    note.set_occasion(params[:occasion_name], current_taster)
  
    if note.update_attributes(params['note'])
      # this reloads associations like lookups that may have been deleted in DB,
      # but not removed from the model that is in memory
      note = @note_class.find(params[:id])
      api_note = build_full_api_note(note)
      render :json => api_note
    else
      render_data_validation_json_error(:update, note)
    end
  end
  
  def build_full_api_note(note)
    tags = note.tags
    api_note = note.api_copy
    api_note.producer_id = note.product.producer_id
    api_note.producer_description = note.product.producer.description
    api_note.product_description = note.product.description
    api_note.tags = tags.collect{|tag| tag.name} if tags.present?
		api_note.occasion = note.occasion.try(:name)
		api_note.region_name = note.product.region.try(:name)
		api_note.style_name = note.product.style.try(:name)
		if note.product.varietals.present?
		  api_note.varietal_names = note.product.varietals.collect{|varietal| varietal.name} 
		end
		if note.product.vineyards.present?
		  api_note.vineyard_names = note.product.vineyards.collect{|vineyard| vineyard.name} 
		end
		
    return api_note
  end
  
  
end
