
require 'api/query_results'

class ApiProductsController < ApiEntitiesController

  def show
    product = find_product_by_canonical_name_or_id(displayed_taster, params[:id])
    if (test_visibility(product, current_taster))
      render :json => build_full_api_product(product)
    else
      # just return the name without any scandalous details
      render :json => product.api_copy(false)
    end
  end
  
  def show_simple
    product = find_product_by_canonical_names(current_taster, 
                params[:producer_name].try(:canonicalize), params[:name].try(:canonicalize))
    if product.present?
      copy = product.simple_copy
      render :json => copy
    else
      results = Api::QueryResults.new(:simple_product)
      render :json => results, :status => 404
    end
  end
  
  def create
    producer_name = params[:product][:producer_name]
    product_name = params[:product][:name]
    existing_product = find_product_by_canonical_names(current_taster, 
                producer_name.try(:canonicalize), 
                product_name.try(:canonicalize))
    if existing_product.present?
      render_duplicate_entity_json_error(:create, existing_product, producer_name + " " + product_name)
      return
    end
    
    product = @product_class.new(params[:product])
    product.update_tags(params[:tags], current_taster)
    product.set_lookup_properties(params, current_taster, @producer_class)
    if product.save
      # need to do this to pull in tags
      product = @product_class.find(product.id)
      render :json => build_full_api_product(product)
    else
      render_data_validation_json_error(:create, product)
    end
  end

  def update
    product = find_product_by_canonical_name_or_id(current_taster, params[:id])
    # have to update tags before setting lookups, because the function
    # would remove the auto-tag
    product.update_tags(params[:tags], current_taster)
    product.set_lookup_properties(params, current_taster, @producer_class)
    if product.update_attributes(params['product'])
      # this reloads associations like lookups that may have been deleted in DB,
      # but not removed from the model that is in memory
      product = find_product_by_canonical_name_or_id(current_taster, params[:id])
      render :json => build_full_api_product(product)
    else
      render_data_validation_json_error(:update, product)
    end
  end
  
  def autocomplete
    max_results = params[:max_results].try(:to_i) || API_MAX_ENTITY_RESULTS;
    canonical_producer_name = params[:producer_name].try(:canonicalize)
    canonical_query = params[:query].try(:canonicalize)

    products = match_products_by_canonical_name(canonical_producer_name, canonical_query, max_results)
    
    reference_products = []
    lookups = []
    if products.count < max_results
      reference_products = match_reference_products_by_canonical_name(canonical_producer_name, canonical_query, max_results)
      if (products.count + reference_products.count) < max_results
        case @beverage_type
        when :wine then
          lookups = match_reference_regions_and_varietals(canonical_query, max_results)
        when :beer then
          lookups = match_reference_beer_styles(canonical_query, max_results)
        when :spirits then
          lookups = match_reference_spirit_styles(canonical_query, max_results)
        end
      end
    end
    
    query_results = Api::QueryResults.new(:autocomplete_product_name)
    
    append_autocomplete_names(query_results, products, max_results)
    append_autocomplete_names(query_results, reference_products, max_results, true)
    append_autocomplete_names(query_results, lookups, max_results, true)
      
    render :json => query_results
  end
  
  def build_full_api_product(product)
    tags = product.tags
    notes = find_product_notes(product, MAX_BEVERAGE_RESULTS)
    
    api_product = product.api_copy
    api_product.producer_description = product.producer.description
    api_product.tags = tags.collect{|tag| tag.name} if tags.present?
    api_product.notes = notes.collect{|note| note.api_copy} if notes.present?
  
		api_product.region_name = product.region.try(:name)
		api_product.style_name = product.style.try(:name)
		api_product.varietal_names = product.varietals.collect{|varietal| varietal.name} if product.varietals.present?
		api_product.vineyard_names = product.vineyards.collect{|vineyard| vineyard.name} if product.vineyards.present?
    
    return api_product
  end
  
end
