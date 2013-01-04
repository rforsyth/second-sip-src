
require 'api/query_results'
require 'api/error_results'

class ApiEntitiesController < ApiController
  
  API_MAX_ENTITY_RESULTS = 100
  
  def index
    max_results = params[:max_results].try(:to_i) || API_MAX_ENTITY_RESULTS;
    visibility = (params[:visibility].present?) ? params[:visibility].to_i : 10
    case visibility
    when Enums::Visibility::PRIVATE then
      entities = find_beverage_by_owner_and_tags(@current_entity_class,
                     current_taster, current_taster, params[:in], params[:ain], 
                     max_results, false)
    when Enums::Visibility::FRIENDS then
      entities = find_global_beverage_by_tags(@current_entity_class, 
                    current_taster, params[:in], params[:ain], false, 
                    max_results, false)
    when Enums::Visibility::PUBLIC then
      entities = find_global_beverage_by_tags(@current_entity_class, 
                    current_taster, params[:in], params[:ain], true, max_results, false)
    end            
    beverage_list = serialize_beverage_list(entities)
    render :json => beverage_list
  end
  
  def search
    visibility = (params[:visibility].present?) ? params[:visibility].to_i : 10
    case visibility
    when Enums::Visibility::PRIVATE then
      entities = search_beverage_by_owner(@current_entity_class, params[:query],
                                            current_taster, current_taster)
    when Enums::Visibility::FRIENDS then
      entities = search_friends_beverage(@current_entity_class, params[:query],
                                            current_taster)
    when Enums::Visibility::PUBLIC then
      entities = search_global_beverage(@current_entity_class, params[:query],
                                            current_taster)
    end
    render :json => serialize_beverage_list(entities)
  end
  
  def common_tags
    max_results = params[:max_results].try(:to_i) || API_MAX_ENTITY_RESULTS;
    tagified_query = params[:query].try(:tagify)
    owner_id = current_taster.id
    entity_name = @current_entity_class.name
    
	  tag_names = ActiveRecord::Base.connection.select_values(
	    "SELECT name FROM tags 
      INNER JOIN tagged ON tags.id = tagged.tag_id
        AND tags.entity_type = '#{entity_name}'
        AND tagged.owner_id = #{owner_id}
      GROUP BY name
      ORDER BY COUNT(name) DESC
      LIMIT #{max_results}")
  	
    results = Api::QueryResults.new(:autocomplete_tag)
        
    tag_names.each do |tag_name|
      results.add(tag_name)
    end
    render :json => results
  end

  
  def tag_autocomplete
    max_results = params[:max_results].try(:to_i) || API_MAX_ENTITY_RESULTS;
    tagified_query = params[:query].try(:tagify)
    visibility = (params[:visibility].present?) ? params[:visibility].to_i : 10
    if visibility == Enums::Visibility::PRIVATE
      tags = Tag.find_by_sql(
        ["SELECT DISTINCT tags.* FROM tags 
          INNER JOIN tagged ON tags.id = tagged.tag_id
          WHERE tags.name LIKE ?
            AND tags.entity_type = ?
            AND tagged.owner_id = ?
          LIMIT ?",
          "%#{tagified_query}%", @current_entity_class.name, current_taster.id, max_results])
    else
      # just remove the owner clause
      tags = Tag.find_by_sql(
        ["SELECT DISTINCT tags.* FROM tags 
          INNER JOIN tagged ON tags.id = tagged.tag_id
          WHERE tags.name LIKE ?
            AND tags.entity_type = ?
          LIMIT ?",
          "%#{tagified_query}%", @current_entity_class.name, max_results])
    end
        
    results = Api::QueryResults.new(:autocomplete_tag)
        
    tags.each do |tag|
      results.add(tag.name)
    end
    render :json => results
  end
  
  #http://api.ssdev.com:3000/wines/lookup_autocomplete?query=Hell&lookup_type=20&max_results=50

  
  def lookup_autocomplete
    max_results = params[:max_results].try(:to_i) || API_MAX_ENTITY_RESULTS;
    lookups = find_lookups(params[:query], @current_entity_class.name,
                params[:lookup_type], current_taster, max_results)
    if lookups.count < max_results
      reference_lookups = find_reference_lookups(params[:query],
                "Reference#{@current_entity_class.name}",
                params[:lookup_type], max_results)
    else
      reference_lookups = []
    end
    
    query_results = Api::QueryResults.new(:autocomplete_lookup)

    lookups.each do |lookup|
	    query_results.add(lookup.name)
    end
    reference_lookups.each do |lookup|
      break if query_results.results.count > max_results
      if !query_results.results.include?(lookup.name)
	      query_results.add(lookup.name)
	    end
    end
    render :json => query_results
  end
  
  def serialize_beverage_list(beverages)
    
    results = Api::QueryResults.new(:newest)
    
    beverages.each do |beverage|
	    results.add(beverage.api_copy)
    end
    results
  end
  
  protected
  
  def append_autocomplete_names(query_results, entities, max_results, avoid_duplicates = false)
    entities.each do |entity|
      break if query_results.results.count > max_results
      if avoid_duplicates
        if !query_results.results.include?(entity.name)
  	      query_results.add(entity.name)
  	    end
      else
  	    query_results.add(entity.name)
      end
    end
  end
  
end