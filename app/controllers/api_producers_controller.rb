
require 'api/query_results'

class ApiProducersController < ApiController
  
  def index
    producers = find_beverage_by_owner_and_tags(@producer_class,
                   current_taster, current_taster, params[:in], params[:ain])
                   
                   
    beverage_list = serialize_beverage_list(producers)
    
    puts beverage_list.to_json
    
    render :json => beverage_list
  end
  
  def search
    producers = search_beverage_by_owner(@producer_class, params[:query],
                                          current_taster, current_taster)
    render :json => serialize_beverage_list(producers)
  end
  
  
  def autocomplete
    max_results = params[:max_results] || API_MAX_BEVERAGE_RESULTS;
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
  
  def show
    producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    render :json => build_full_api_producer(producer)
  end
  
  def create
    producer = @producer_class.new(params['producer'])
    if @producer.save
      # remove tags that aren't in producer.tags, and add ones that are there but not added yet
      render :json => build_full_api_producer(producer)
    else
      # send error message back
    end
  end

  def update
    puts 'inside update'
    producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    if producer.update_attributes(params['producer'])
      puts 'updated'
      # remove tags that aren't in producer.tags, and add ones that are there but not added yet
      render :json => build_full_api_producer(producer)
    else
      # render :action => "producers/edit"
    end
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
