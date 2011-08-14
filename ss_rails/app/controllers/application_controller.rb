require 'ui/tab_builder'

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
  
  ################################################################
	###   Navigation
	################################################################
	
	def initialize_beverage_topnav
		@topnav_tabs = build_beverage_topnav_tabs(:home, @displayed_profile, @current_profile)
	end
	
	def initialize_admin_topnav
		@topnav_tabs = build_admin_topnav_tabs
	end
	
	def initialize_beverage_subnav
		@subnav_tabs = build_beverage_subnav_tabs(@selected_subnav_tab)
	end
	
	def initialize_metadata_subnav
		@subnav_tabs = build_metadata_subnav_tabs
	end
	
	def initialize_users_subnav
		@subnav_tabs = build_users_subnav_tabs
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
  
  def displayed_taster
    return @displayed_taster if defined?(@displayed_taster)
    @displayed_taster = Taster.find_by_username(params[:taster_id])
  end
  
end
