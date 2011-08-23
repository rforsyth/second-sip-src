require 'ui/tab_builder'
require 'ajax/autocomplete'

class ApplicationController < ActionController::Base
	include UI::TabBuilder
  protect_from_forgery
  
  helper_method :current_taster
  helper_method :displayed_taster

  protected
  
  def find_by_owner_and_canonical_name_or_id(model_class, owner, id)
    return model_class.find(id) if id.is_i?
    model_class.find_by_canonical_name(id, :conditions => { :owner_id => owner.id } )
  end
  
  def find_by_canonical_name_or_id(model_class, id)
    return model_class.find(id) if id.is_i?
    model_class.find_by_canonical_name(id)
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
  
end
