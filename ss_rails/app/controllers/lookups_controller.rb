require 'ui/admin_taggable_controller'

class LookupsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_lookup, :only => [ :show, :edit, :update,
                                         :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
	before_filter :initialize_lookups_tabs
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    
    lookups = find_lookups(params[:query], params[:entity_type],
                params[:lookup_type], current_taster, MAX_AUTOCOMPLETE_RESULTS)
                
    if lookups.count < MAX_AUTOCOMPLETE_RESULTS
      reference_lookups = find_reference_lookups(params[:query],
                "Reference#{params[:entity_type]}",
                params[:lookup_type], MAX_AUTOCOMPLETE_RESULTS)
    else
      reference_lookups = []
    end

    lookups.each do |lookup|
	    autocomplete.add_suggestion(lookup.name, lookup.name, lookup.id)
    end
    reference_lookups.each do |lookup|
      break if autocomplete.suggestions.count > MAX_AUTOCOMPLETE_RESULTS
      if !autocomplete.includes_value?(lookup.name)
	      autocomplete.add_suggestion(lookup.name, lookup.name, lookup.id)
	    end
    end
    render :json => autocomplete
  end
  
  def search
    canonical_query = params[:query].try(:canonicalize)
    @lookups = Lookup.where(["canonical_name LIKE ?", "%#{canonical_query}%"]
                           ).limit(MAX_BEVERAGE_RESULTS)
  end
	
  def index
    @lookups = find_by_admin_tags(Lookup, params[:ain])
    build_admin_tag_filter(@lookups)
  end

  def show
  end

  def new
    @lookup = Lookup.new
  end

  def create
    @lookup = Lookup.new(params[:lookup])
    if @lookup.save
      redirect_to(@lookup)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @lookup.update_attributes(params[:lookup])
      redirect_to(@lookup)
    else
      render :action => "edit"
    end
  end
	
  ############################################
  ## Helpers
	
	private
	
	def find_lookup
    @lookup = Lookup.find(params[:id])
  end
  
  def set_tag_container
    @tag_container = @lookup
  end
  
end
