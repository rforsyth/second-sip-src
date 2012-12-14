
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
    product = @product_class.new(params['product'])
    product.set_lookup_properties(params, current_taster, @producer_class)
    if product.save
      product.update_tags params[:tags]
      render :json => build_full_api_product(product)
    else
      render_data_validation_json_error(:create, product)
    end
  end

  def update
    product = find_product_by_canonical_name_or_id(current_taster, params[:id])
    if product.update_attributes(params['product'])
      product.set_lookup_properties(params, current_taster, @producer_class)
      product.update_tags params[:tags]
      
      # this reloads associations like lookups that may have been deleted in DB,
      # but not removed from the model that is in memory
      product = find_product_by_canonical_name_or_id(current_taster, params[:id])
      render :json => build_full_api_product(product)
    else
      render_data_validation_json_error(:update, product)
    end
  end
  
  def autocomplete
    max_results = params[:max_results] || API_MAX_ENTITY_RESULTS;
    canonical_query = params[:query].try(:canonicalize)

    reference_products = @reference_product_class.where(
                  ["reference_products.canonical_name LIKE ?", "%#{canonical_query}%"]
                  ).limit(max_results)
    
    #products = @product_class.where(:owner_id => current_taster.id,
    #                 ).where("products.canonical_name LIKE ?", "%#{canonical_query}%"
    #                 ).limit(max_results)
    
    results = Api::QueryResults.new(:autocomplete_product_name)
                     
    reference_products.each do |reference_product|
      results.add(reference_product.name)
    end
    render :json => results
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
