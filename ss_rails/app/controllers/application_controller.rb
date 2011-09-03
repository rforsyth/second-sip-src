require 'ui/tab_builder'
require 'ajax/autocomplete'

class ApplicationController < ActionController::Base
	include UI::TabBuilder
  protect_from_forgery
  
  helper_method :current_taster
  helper_method :displayed_taster

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
  end
  
  def require_taster 
    unless current_taster 
      store_location 
      flash[:notice] = "You must be logged in to access this page" 
      redirect_to login_path 
      return false 
    end 
  end
  
  def require_no_taster
    if current_taster 
      store_location 
      flash[:notice] = "You must be logged out to access this page" 
      redirect_to root_url 
      return false 
    end 
  end
  
  def displayed_taster
    return @displayed_taster if defined?(@displayed_taster)
    @displayed_taster = Taster.find_by_username(params[:taster_id])
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
    return if tag_containers.nil?
    tag_containers.each do |tag_container|
      tag_container.tags.each do |tag|
        @available_tags << tag.name if !@available_tags.include?(tag.name)
      end
    end
    @available_tags = @available_tags - (@included_tags + @excluded_tags)
  end
  
  def build_admin_tag_filter(tag_containers)
		@included_admin_tags = params[:ain] || []
		@excluded_admin_tags = params[:aex] || []
    @available_admin_tags = []
    return if tag_containers.nil?
    tag_containers.each do |tag_container|
      tag_container.admin_tags.each do |admin_tag|
        @available_admin_tags << admin_tag.name if !@available_admin_tags.include?(admin_tag.name)
      end
    end
    @available_admin_tags = @available_admin_tags - (@included_admin_tags + @excluded_admin_tags)
  end
  
  def polymorphic_find_by_owner_and_tags(model, owner, user_tags, admin_tags)
    if user_tags.present?
      return model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name} 
          INNER JOIN tagged ON #{model.table_name}.id = tagged.taggable_id
          INNER JOIN tags ON tagged.tag_id = tags.id
          WHERE #{model.table_name}.owner_id = ?
            AND #{model.table_name}.type = ?
            AND tags.name IN (?)",
          owner.id, model.name, user_tags])
    end
    polymorphic_find_by_owner_and_admin_tags(model, owner, admin_tags)
  end
  
  def polymorphic_find_by_owner_and_admin_tags(model, owner, admin_tags)
    if admin_tags.present?
      return model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name} 
          INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
          INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
          WHERE #{model.table_name}.owner_id = ?
            AND #{model.table_name}.type = ?
            AND admin_tags.name IN (?)",
          owner.id, model.name, admin_tags])
    end
    model.find_all_by_owner_id(owner.id)
  end
  
  def polymorphic_find_by_tags(model, user_tags, admin_tags)
    if user_tags.present?
      return model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name} 
          INNER JOIN tagged ON #{model.table_name}.id = tagged.taggable_id
          INNER JOIN tags ON tagged.tag_id = tags.id
          WHERE #{model.table_name}.type = ?
            AND tags.name IN (?)",
          model.name, user_tags])
    end
    polymorphic_find_by_admin_tags(model, admin_tags)
  end
  
  def polymorphic_find_by_admin_tags(model, admin_tags)
    if admin_tags.present?
      return model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name} 
          INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
          INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
          WHERE #{model.table_name}.type = ?
            AND admin_tags.name IN (?)",
          model.name, admin_tags])
    end
    model.all
  end
  
  def find_by_admin_tags(model, admin_tags)
    if admin_tags.present?
      return model.find_by_sql(
        ["SELECT DISTINCT #{model.table_name}.* FROM #{model.table_name} 
          INNER JOIN admin_tagged ON #{model.table_name}.id = admin_tagged.admin_taggable_id
          INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
          WHERE admin_tags.name IN (?)",
          admin_tags])
    end
    model.all
  end
    
  
end
