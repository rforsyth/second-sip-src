require 'ui/tab_builder'
require 'ajax/autocomplete'
require 'data/cache_helper'
require 'exceptions/exception_loggable'
require 'api/error_results'

class ApplicationController < ActionController::Base
	include UI::TabBuilder
  include Data::CacheHelper
  include ExceptionLogger::ExceptionLoggable
  
  protect_from_forgery
  
  BEVERAGE_PAGE_SIZE = 20
  MAX_PAGE_NUM = 10
  MAX_BEVERAGE_RESULTS = 200
  MAX_AUTOCOMPLETE_RESULTS = 8
  
  helper_method :current_taster, :displayed_taster
  helper_method :fetch_taster
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction, :with => :render_not_found
  end
  
  def render_not_found(exception)
    log_exception(exception)
    flash[:notice] = 'The resource was not found.  Sorry for any inconvenience'
    respond_to do |format|
      format.html do 
        render :template => 'errors/message', :layout => 'single_column', :status => 404
      end
      format.json do
        response = Api::ErrorResults.new(:fatal_exception, 'Data Not Found', 
          'We were unable to find data that matched your request.  Sorry for any inconvenience.')
        render :json => response, :status => 500
      end
    end
  end

  def render_error(exception)
    log_exception(exception)
    flash[:notice] = 'An unexepected server error occurred.  Sorry for any inconvenience'
    respond_to do |format|
      format.html do 
        render :template => 'errors/message', :layout => 'single_column', :status => 500
      end
      format.json do
        response = Api::ErrorResults.new(:fatal_exception, 'Unexpected Error', 
          'We were unable to complete the operation due to an unexpected server error. Sorry for any inconvenience.')
        render :json => response, :status => 500
      end
    end
  end

  protected
  
  def find_producer_by_canonical_name_or_id(owner, id)
    return @producer_class.find(id) if id.is_i?
    @producer_class.find_by_canonical_name(id, :conditions => { :owner_id => owner.id } )
  end
  
  def find_reference_producer_by_canonical_name_or_id(id)
    return @reference_producer_class.find(id) if id.is_i?
    @reference_producer_class.find_by_canonical_name(id)
  end
  
  def find_product_by_canonical_name_or_id(owner, id)
    return @product_class.find(id) if id.is_i?
    canonical_names = id.split('-')
    raise "invalid product canonical name: #{id}" if canonical_names.length != 2
    find_product_by_canonical_names(owner, canonical_names[0], canonical_names[1])
  end
  
  def find_product_by_canonical_names(owner, producer_name, product_name)
    @product_class.all(
      :readonly => false,
      :joins => :producer,
      :conditions => {
        :owner_id => owner.id,
        :canonical_name => product_name,
        :producers => { :owner_id => owner.id,
                        :canonical_name => producer_name }}
      ).first
  end
  
  def find_reference_product_by_canonical_name_or_id(id)
    return @reference_product_class.find(id) if id.is_i?
    canonical_names = id.split('-')
    raise "invalid product canonical name: #{id}" if canonical_names.length != 2
    @reference_product_class.all(
      :readonly => false,
      :joins => :reference_producer,
      :conditions => {
        :canonical_name => canonical_names[1],
        :reference_producers => { :canonical_name => canonical_names[0] }}
      ).first
  end
  
  def find_by_name_or_id(model_class, id)
    return model_class.find(id) if id.is_i?
    model_class.find_by_name(id)
  end
  
  def remember_visibility(entity)
	  cookies[:last_visibility] = entity.visibility
  end
    
  private
  
  def initialize_beverage_classes(current_beverage_type)
    @beverage_type = current_beverage_type
    case current_beverage_type
    when :beer then
      @producer_class = Brewery
      @product_class = Beer
      @note_class = BeerNote
      @reference_producer_class = ReferenceBrewery
      @reference_product_class = ReferenceBeer
    when :wine then
      @producer_class = Winery
      @product_class = Wine
      @note_class = WineNote
      @reference_producer_class = ReferenceWinery
      @reference_product_class = ReferenceWine
    when :spirits then
      @producer_class = Distillery
      @product_class = Spirit
      @note_class = SpiritNote
      @reference_producer_class = ReferenceDistillery
      @reference_product_class = ReferenceSpirit
    end
  end

  def current_taster_session
    return @current_taster_session if defined?(@current_taster_session)
    @current_taster_session = TasterSession.find
  end
  
  def current_taster
    return @current_taster if defined?(@current_taster)
    @current_taster = current_taster_session && current_taster_session.record
    store_taster(@current_taster) if @current_taster
    return @current_taster
  end
  
  def require_taster 
    unless current_taster
      flash[:notice] = "You must be signed in to access this page" 
      redirect_to login_path(:redir => request.fullpath)
      return false 
    end 
  end
  
  def require_no_taster
    if current_taster
      flash[:notice] = "You cannot access this page while signed in" 
      render :template => 'errors/message', :layout => 'single_column'
      return false 
    end 
  end
  
  def require_editor
    if !(current_taster && current_taster.is?(:editor))
      flash[:notice] = "You do not have permission to access this page" 
      render :template => 'errors/message', :layout => 'single_column', :status => :forbidden
      return false 
    end
  end
  
  def require_admin
    if !(current_taster && current_taster.is?(:admin))
      flash[:notice] = "You do not have permission to access this page" 
      render :template => 'errors/message', :layout => 'single_column', :status => :forbidden
      return false 
    end
  end
  
  def require_viewing_own_data
    if !(current_taster && 
         (displayed_taster == current_taster ||
         current_taster.is?(:admin)))
      flash[:notice] = "You do not have permission to access this page" 
      render :template => 'errors/message', :layout => 'single_column', :status => :forbidden
      return false 
    end
  end
  
  def require_visibility_helper(entity)
    if !(test_visibility(entity, current_taster))
      if current_taster.nil?
        flash[:notice] = "You must be signed in to access this page" 
        redirect_to login_path(:redir => request.fullpath)
      else
        flash[:notice] = "You do not have permission to access this page" 
        render :template => 'errors/message', :layout => 'single_column', :status => :forbidden
      end
      return false 
    end
  end
  
  def require_displayed_taster
    if displayed_taster.nil?
      if params[:taster_id].present?
        flash[:notice] = "The taster: #{params[:taster_id]} could not be found in the database"
      else 
        flash[:notice] = "We could not find the page that you are looking for"
      end
      render :template => 'errors/message', :layout => 'single_column', :status => 404
      return false 
    end
  end
  
  def displayed_taster
    return @displayed_taster if defined?(@displayed_taster)
    @displayed_taster = Taster.find_by_username(params[:taster_id])
    store_taster(@displayed_taster) if @displayed_taster
    return @displayed_taster
  end
  
  def initialize_beverage_classes_from_entity_type_param
    beverage_type = case params[:entity_type]
      when 'breweries', 'beers', 'beer_notes' then :beer
      when 'wineries', 'wines', 'wine_notes' then :wine
      when 'distilleries', 'spirits', 'spirit_notes' then :spirits
      else raise "Unexpected entity type: #{params[:entity_type]}"
      end
    initialize_beverage_classes(beverage_type)
  end
  
  def build_tag_filter(tag_containers)
		@included_tags = params[:in] || []
		@excluded_tags = params[:ex] || []
    @available_tags = []
    return if !tag_containers.present?

    tags = find_tags(tag_containers.collect{|container| container.id},
                     tag_containers.first.class)    
    tags.each do |tag|
      @available_tags << tag.name if !@available_tags.include?(tag.name)
    end
    @available_tags = @available_tags - (@included_tags + @excluded_tags)
  end
  
  def build_admin_tag_filter(tag_containers)
    return if !(current_taster && current_taster.is?(:admin))
    
		@included_admin_tags = params[:ain] || []
		@excluded_admin_tags = params[:aex] || []
    @available_admin_tags = []
    return if !tag_containers.present?
    
    admin_tags = find_admin_tags(tag_containers.collect{|container| container.id},
                                 tag_containers.first.class)
    admin_tags.each do |admin_tag|
      @available_admin_tags << admin_tag.name if !@available_admin_tags.include?(admin_tag.name)
    end
    @available_admin_tags = @available_admin_tags - (@included_admin_tags + @excluded_admin_tags)
  end
  
  
  def search_beverage_by_owner(model, query, owner, viewer)
    if owner == viewer
      results = model.search(query).where({:owner_id => owner.id}).limit(MAX_BEVERAGE_RESULTS)
    elsif viewer.present? && viewer.friends.include?(owner)
      results = model.search(query).where(
                  "visibility >= ? AND owner_id = ?",
                  Enums::Visibility::FRIENDS, owner.id
                  ).limit(MAX_BEVERAGE_RESULTS)
    else
      results = model.search(query).where(
                  "visibility >= ? AND owner_id = ?",
                  Enums::Visibility::PUBLIC, owner.id
                  ).limit(MAX_BEVERAGE_RESULTS)
    end
    page_beverage_results(results)
  end
  
  def search_friends_beverage(model, query, viewer)
    friend_ids = collect_friend_ids(viewer)
    if friend_ids.present?
      results = model.search(query).where(
                  "(visibility >= ? AND owner_id = ?) OR (visibility >= ? AND owner_id IN (?))",
                  Enums::Visibility::PRIVATE, viewer.id, Enums::Visibility::FRIENDS, friend_ids
                  ).limit(MAX_BEVERAGE_RESULTS)
    else
      results = model.search(query).where(
                  "visibility >= ? AND owner_id = ?",
                  Enums::Visibility::PRIVATE, viewer.id
                  ).limit(MAX_BEVERAGE_RESULTS)
    end
    page_beverage_results(results)
  end
  
  def search_global_beverage(model, query, viewer)
    friend_ids = collect_friend_ids(viewer)
    if friend_ids.present?
      results = model.search(query).where(
                  "visibility >= ? OR (visibility >= ? AND owner_id IN (?)) OR (visibility >= ? AND owner_id = ?)",
                  Enums::Visibility::PUBLIC, Enums::Visibility::FRIENDS, friend_ids,
                  Enums::Visibility::PRIVATE, viewer.id
                  ).limit(MAX_BEVERAGE_RESULTS)
    else
      results = model.search(query).where(
                  "visibility >= ? OR (visibility >= ? AND owner_id = ?)",
                  Enums::Visibility::PUBLIC, Enums::Visibility::PRIVATE, viewer.id
                  ).limit(MAX_BEVERAGE_RESULTS)
    end
    page_beverage_results(results)
  end
  
  def find_beverage_by_owner_and_tags(model, owner, viewer, user_tags, admin_tags, 
                                      max_results = MAX_BEVERAGE_RESULTS, page = true)
    if user_tags.present?
      query = "SELECT #{model.table_name}.* FROM #{model.table_name} 
        INNER JOIN tagged ON #{model.table_name}.id = tagged.taggable_id
        INNER JOIN tags ON tagged.tag_id = tags.id
        WHERE #{model.table_name}.owner_id = #{owner.id}
          AND #{model.table_name}.type = '#{model.name}'
          AND tags.name = ?
          AND #{known_owner_visibility_clause(model, owner, viewer)}"
      summary = "ORDER BY created_at DESC
        LIMIT #{max_results}"
        
      query = format_tag_intersection_query(query, summary, user_tags)
      
      results = model.find_by_sql([query, user_tags].flatten)
      return (page) ? page_beverage_results(results) : results
    end
    find_beverage_by_owner_and_admin_tags(model, owner, viewer, admin_tags, max_results, page)
  end
  
  
  def find_beverage_by_owner_and_admin_tags(model, owner, viewer, admin_tags, 
                                      max_results = MAX_BEVERAGE_RESULTS, page = true)
    if admin_tags.present?
      query = "SELECT #{model.table_name}.* FROM #{model.table_name} 
        INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
        INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
        WHERE #{model.table_name}.owner_id = #{owner.id}
          AND #{model.table_name}.type = '#{model.name}'
          AND admin_tags.name = ?
          AND admin_tagged.admin_taggable_type = '#{model.superclass.name}'
          AND #{known_owner_visibility_clause(model, owner, viewer)}"
      summary = "ORDER BY created_at DESC
        LIMIT #{max_results}"
        
      query = format_tag_intersection_query(query, summary, admin_tags)
      
      results = model.find_by_sql([query, admin_tags].flatten)
    else
      results = model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name}
          WHERE #{model.table_name}.owner_id = ?
            AND #{model.table_name}.type = ?
            AND #{known_owner_visibility_clause(model, owner, viewer)}
          ORDER BY created_at DESC
          LIMIT ?",
          owner.id, model.name, max_results])
    end
    return (page) ? page_beverage_results(results) : results
  end
  
  def find_global_beverage_by_tags(model, viewer, user_tags, admin_tags,
                                   include_public = true, max_results = MAX_BEVERAGE_RESULTS, page = true)
    if user_tags.present?
      query = "SELECT #{model.table_name}.* FROM #{model.table_name} 
        INNER JOIN tagged ON #{model.table_name}.id = tagged.taggable_id
        INNER JOIN tags ON tagged.tag_id = tags.id
        WHERE #{model.table_name}.type = '#{model.name}'
          AND tags.name = ?
          AND #{global_visibility_clause(model, viewer, include_public)}"
      summary = "ORDER BY created_at DESC
        LIMIT #{max_results}"
      query = format_tag_intersection_query(query, summary, user_tags)
      results = model.find_by_sql([query, user_tags].flatten)
      return (page) ? page_beverage_results(results) : results
    end
    find_global_beverage_by_admin_tags(model, viewer, admin_tags, include_public, max_results, page)
  end
  
  def find_global_beverage_by_admin_tags(model, viewer, admin_tags,
                                   include_public = true, max_results = MAX_BEVERAGE_RESULTS, page = true)
    if admin_tags.present?
      query = "SELECT #{model.table_name}.* FROM #{model.table_name} 
        INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
        INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
        WHERE #{model.table_name}.type = '#{model.name}'
          AND admin_tags.name = ?
          AND admin_tagged.admin_taggable_type = '#{model.superclass.name}'
          AND #{global_visibility_clause(model, viewer, include_public)}"
      summary = "ORDER BY created_at DESC
        LIMIT #{max_results}"
      query = format_tag_intersection_query(query, summary, admin_tags)
      results = model.find_by_sql([query, admin_tags].flatten)
    else
      results = model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name}
          WHERE #{model.table_name}.type = ?
            AND #{global_visibility_clause(model, viewer, include_public)}
          ORDER BY created_at DESC
          LIMIT ?",
          model.name, max_results])
    end
    return (page) ? page_beverage_results(results) : results
  end
  
  def find_reference_beverage_by_admin_tags(model, viewer, admin_tags)
    if admin_tags.present?
      query = "SELECT #{model.table_name}.* FROM #{model.table_name} 
        INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
        INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
        WHERE #{model.table_name}.type = '#{model.name}'
          AND admin_tagged.admin_taggable_type = '#{model.superclass.name}'
          AND admin_tags.name = ?"
      summary = "ORDER BY created_at DESC
        LIMIT #{MAX_BEVERAGE_RESULTS}"
      query = format_tag_intersection_query(query, summary, admin_tags)
      results = model.find_by_sql([query, admin_tags].flatten)
    else
      results = model.limit(MAX_BEVERAGE_RESULTS)
    end
    page_beverage_results(results)
  end
  
  def find_by_admin_tags(model, admin_tags)
    if admin_tags.present?
      query = "SELECT #{model.table_name}.* FROM #{model.table_name} 
        INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
        INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
        WHERE admin_tags.name = ?
          AND admin_tagged.admin_taggable_type = '#{model.name}'"
      summary = "ORDER BY created_at DESC
        LIMIT #{MAX_BEVERAGE_RESULTS}"
      query = format_tag_intersection_query(query, summary, admin_tags)
      results = model.find_by_sql([query, admin_tags].flatten)
    else
      results = model.limit(MAX_BEVERAGE_RESULTS)
    end
    page_beverage_results(results)
  end
  
  def find_tags(taggable_ids, taggable_type)
    taggable_type_name = taggable_type.name
    taggable_type_name = taggable_type.superclass.name if taggable_type.superclass != ActiveRecord::Base
    Tag.find_by_sql(["SELECT COUNT(t.id), t.id, t.creator_id, t.updater_id, t.name, t.created_at, t.updated_at, t.entity_type
                      FROM tags t
                      INNER JOIN tagged ON t.id = tagged.tag_id
                      WHERE tagged.taggable_id IN (?)
                      AND tagged.taggable_type = '#{taggable_type_name}'
                      GROUP BY t.id, t.creator_id, t.updater_id, t.name, t.created_at, t.updated_at, t.entity_type
                      ORDER BY COUNT(t.id) DESC, t.name ASC
                      LIMIT 30",
                      taggable_ids])
  end
  
  def find_admin_tags(taggable_ids, taggable_type)
    taggable_type_name = taggable_type.name
    taggable_type_name = taggable_type.superclass.name if taggable_type.superclass != ActiveRecord::Base
    Tag.find_by_sql(["SELECT COUNT(t.id), t.id, t.creator_id, t.updater_id, t.name, t.created_at, t.updated_at, t.entity_type
                      FROM admin_tags t
                      INNER JOIN admin_tagged ON t.id = admin_tagged.admin_tag_id
                      WHERE admin_tagged.admin_taggable_id IN (?)
                      AND admin_tagged.admin_taggable_type = '#{taggable_type_name}'
                      GROUP BY t.id, t.creator_id, t.updater_id, t.name, t.created_at, t.updated_at, t.entity_type
                      ORDER BY COUNT(t.id) DESC
                      LIMIT 30",
                      taggable_ids])
  end
  
  def find_lookups(query, entity_type, lookup_type, owner, max_results)
    canonical_query = query.try(:canonicalize)
    Lookup.find_by_sql(
      ["SELECT DISTINCT lookups.* FROM lookups 
        INNER JOIN looked ON lookups.id = looked.lookup_id
        WHERE lookups.canonical_name LIKE ?
          AND lookups.entity_type = ?
          AND lookups.lookup_type = ?
          AND looked.owner_id = ?
        LIMIT ?",
        "%#{canonical_query}%", entity_type,
        lookup_type.to_i, owner.id, max_results])
  end
  
  def find_reference_lookups(query, entity_type, lookup_type, max_results)
    canonical_query = query.try(:canonicalize)
    ReferenceLookup.find_by_sql(
      ["SELECT DISTINCT reference_lookups.* FROM reference_lookups 
        WHERE reference_lookups.canonical_name LIKE ?
          AND reference_lookups.entity_type = ?
          AND reference_lookups.lookup_type = ?
        ORDER BY name ASC
        LIMIT ?",
        "%#{canonical_query}%", entity_type,
        lookup_type.to_i, max_results])
  end
  
  def find_producer_notes(producer, max_results)
    @note_class.find_by_sql(
      ["SELECT DISTINCT notes.* FROM notes 
        INNER JOIN products ON notes.product_id = products.id
        INNER JOIN producers ON products.producer_id = producers.id
        WHERE producers.id = ?
          AND #{known_owner_visibility_clause(@note_class, producer.owner, current_taster)}
        ORDER BY created_at DESC
        LIMIT ?",
        producer.id, max_results])
  end
  
  def find_producer_products(producer, max_results)
    @product_class.find_by_sql(
      ["SELECT DISTINCT products.* FROM products
        INNER JOIN producers ON products.producer_id = producers.id
        WHERE producers.id = ?
          AND #{known_owner_visibility_clause(@product_class, producer.owner, current_taster)}
        ORDER BY created_at DESC
        LIMIT ?",
        producer.id, max_results])
  end
  
  def find_product_notes(product, max_results)
    @note_class.find_by_sql(
      ["SELECT DISTINCT notes.* FROM notes 
        INNER JOIN products ON notes.product_id = products.id
        WHERE products.id = ?
          AND #{known_owner_visibility_clause(@note_class, product.owner, current_taster)}
        ORDER BY created_at DESC
        LIMIT ?",
        product.id, max_results])
  end
  
  def match_products_by_canonical_name(canonical_producer_name, canonical_query, max_results)
    @product_class.joins(:producer).where(
                     :owner_id => current_taster.id,
                     :producers => { :owner_id => current_taster.id,
                                     :canonical_name => canonical_producer_name }
                     ).where("products.canonical_name LIKE ?", "%#{canonical_query}%"
                     ).limit(max_results)
  end
  
  def match_reference_products_by_canonical_name(canonical_producer_name, canonical_query, max_results)
    @reference_product_class.joins(:reference_producer).where(
                     :reference_producers => { :canonical_name => canonical_producer_name }
                     ).where("reference_products.canonical_name LIKE ?", "%#{canonical_query}%"
                     ).limit(max_results)
  end
  
  def match_reference_regions_and_varietals(canonical_query, max_results)
     ReferenceLookup.find_by_sql(
        ["SELECT DISTINCT reference_lookups.* FROM reference_lookups 
          WHERE reference_lookups.canonical_name LIKE ?
            AND reference_lookups.entity_type = ?
            AND (reference_lookups.lookup_type = ?
                 OR reference_lookups.lookup_type = ?)
          ORDER BY lookup_type DESC, name ASC
          LIMIT ?",
          "%#{canonical_query}%", 'ReferenceWine',
          Enums::LookupType::REGION, Enums::LookupType::VARIETAL,
          max_results])
  end
  
  def set_product_from_params(note)
    params_product = nil
    if params[:producer_name].present? && params[:product_name].present?
      params_product = find_product_by_canonical_names(current_taster,
                       params[:producer_name].canonicalize, params[:product_name].canonicalize)
    end
    if params_product.present?
      if !(note.product.present? && params_product.id == note.product.id)
        note.product = params_product
      end
    elsif !note.product.present?
      note.product = @product_class.new(params[@product_class.name.underscore])
      note.product.name = params[:product_name]
      note.product.visibility = note.visibility
      note.product.set_lookup_properties(params, current_taster, @producer_class)
      note.product.save
    end
    if note.product.present?
      note.product_name = note.product.name 
      note.producer_name = note.product.producer.name if note.product.producer.present?
    end
  end
  
  
  def calculate_page_num
    page_num = params[:page].try(:to_i) || 1
    page_num = 1 if page_num < 1
    page_num = 1 if (page_num * MAX_PAGE_NUM) > MAX_BEVERAGE_RESULTS
    return page_num
  end
  
  def page_beverage_results(results)
    return results if results.count < BEVERAGE_PAGE_SIZE
		@page_num = calculate_page_num
		@page_size = BEVERAGE_PAGE_SIZE
		@num_results = results.count
		first_result_index = (@page_num - 1) * @page_size
		return results[first_result_index, @page_size]
  end
  
  def known_owner_visibility_clause(model, owner, viewer)
    return 'true' if(owner.present? && owner == viewer)
    if viewer.present? && viewer.friends.include?(owner)
      return " #{model.table_name}.visibility >= #{Enums::Visibility::FRIENDS} "
    end
    " #{model.table_name}.visibility = #{Enums::Visibility::PUBLIC} "
  end
  
  def global_visibility_clause(model, viewer, include_public = true)
    if include_public
      clause = " (#{model.table_name}.visibility = #{Enums::Visibility::PUBLIC}"
    else
      clause = " (FALSE "
    end
    
    if viewer.present?
      clause << " OR #{model.table_name}.owner_id = #{viewer.id} "
      friend_ids = collect_friend_ids(viewer)
      if friend_ids.present?
        clause << " OR (#{model.table_name}.visibility = #{Enums::Visibility::FRIENDS}
                   AND #{model.table_name}.owner_id IN (#{friend_ids.join(',')})) "
      end
    end
    return clause + ") "
  end
  
  def format_tag_intersection_query(query, summary, tags)
    intersection_query = ''
    tags.each do |tag|
      if intersection_query.length > 0
        intersection_query << "\n INTERSECT \n"
      end
      intersection_query << query
    end
    intersection_query << "\n #{summary}"
  end
  
  def collect_friend_ids(taster)
    taster.friends.collect{|friend| friend.id} if taster.present?
  end
  
  # returns nil if the beverage is not visible to the viewer
  def test_visibility(beverage, viewer)
    return false if (beverage.visibility < Enums::Visibility::PUBLIC) && viewer.nil?
    return true if !viewer.nil? && viewer.is?(:admin)
    return true if(viewer == beverage.owner ||
                   beverage.visibility == Enums::Visibility::PUBLIC)
    return true if(beverage.visibility == Enums::Visibility::FRIENDS &&
                   viewer.friends.include?(beverage.owner))
    false
  end
  
  def retrieve_reference_lookups(product)
    if product.kind_of?(Beer)
      display_reference_lookup(product.style.try(:canonical_name),
        "ReferenceBeer", Enums::LookupType::STYLE)
    end
  end
  
  def display_reference_lookup(canonical_name, entity_type, lookup_type)
    return if !canonical_name.present?
    lookup = ReferenceLookup.find_by_canonical_name(canonical_name,
              :conditions => { :entity_type => entity_type,
                               :lookup_type => lookup_type })
    @reference_lookups ||= []
    @reference_lookups << lookup
  end
    
  
end
