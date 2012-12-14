
require 'api/query_results'

class ApiProducersController < ApiEntitiesController
  
  def show
    producer = find_producer_by_canonical_name_or_id(current_taster, params[:id])
    if (test_visibility(producer, current_taster))
      render :json => build_full_api_producer(producer)
    else
      # just return the name without any scandalous details
      render :json => producer.api_copy(false)
    end
  end
  
  def show_simple
    producer = find_producer_by_canonical_name_or_id(current_taster, params[:name].try(:canonicalize))
    if producer.present?
      render :json => producer.api_copy
    else
      results = Api::QueryResults.new(:simple_producer)
      render :json => results, :status => 404
    end
  end
  
  def create
    producer_name = params['producer'][:name]
    existing_producer = find_producer_by_canonical_name_or_id(current_taster, 
                          producer_name.try(:canonicalize))
    if existing_producer.present?
      render_duplicate_entity_json_error(:create, existing_producer, producer_name)
      return
    end
    
    producer = @producer_class.new(params['producer'])
    if producer.save
      producer.update_tags params[:tags]
      render :json => build_full_api_producer(producer)
    else
      render_data_validation_json_error(:create, producer)
    end
  end

  def update
    producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    if producer.update_attributes(params['producer'])
      producer.update_tags params[:tags]
      render :json => build_full_api_producer(producer)
    else
      render_data_validation_json_error(:update, producer)
    end
  end
  
  def autocomplete
    max_results = params[:max_results] || API_MAX_ENTITY_RESULTS;
    canonical_query = params[:query].try(:canonicalize)

    reference_producers = @reference_producer_class.where(
                  ["reference_producers.canonical_name LIKE ?", "%#{canonical_query}%"]
                  ).limit(max_results)
    
    #producers = @producer_class.where(:owner_id => current_taster.id,
    #                 ).where("producers.canonical_name LIKE ?", "%#{canonical_query}%"
    #                 ).limit(max_results)
    
    results = Api::QueryResults.new(:autocomplete_producer_name)
                     
    reference_producers.each do |reference_producer|
      results.add(reference_producer.name)
    end
    render :json => results
  end
  
  def build_full_api_producer(producer)
    tags = producer.tags
    notes = find_producer_notes(producer, MAX_BEVERAGE_RESULTS)
    products = find_producer_products(producer, MAX_BEVERAGE_RESULTS)
    
    api_producer = producer.api_copy
    api_producer.tags = tags.collect{|tag| tag.name} if tags.present?
    api_producer.products = products.collect{|product| product.api_copy} if products.present?
    api_producer.notes = notes.collect{|note| note.api_copy} if notes.present?
    return api_producer
  end
  
end
