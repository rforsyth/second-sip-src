require 'ui/admin_taggable_controller'

class ReferenceLookupsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_lookup, :only => [ :show, :edit, :update,
                                                   :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
	before_filter :initialize_reference_lookups_tabs
	before_filter :require_admin, :except => [:autocomplete]
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    
    lookups = find_reference_lookups(params[:query], params[:entity_type],
                params[:lookup_type], MAX_AUTOCOMPLETE_RESULTS)

    lookups.each do |lookup|
	    autocomplete.add_suggestion(lookup.name, lookup.name, lookup.id)
    end
    render :json => autocomplete
  end
  
  def search
    canonical_query = params[:query].try(:canonicalize)
    @lookups = ReferenceLookup.where(["canonical_name LIKE ?", "%#{canonical_query}%"])
  end
	
  def index
    @lookups = find_by_admin_tags(ReferenceLookup, params[:ain])
    build_admin_tag_filter(@lookups)
  end

  def show
  end

  def new
    @lookup = ReferenceLookup.new
  end

  def create
    @lookup = ReferenceLookup.new(params[:reference_lookup])
    if @lookup.save
      redirect_to(@lookup)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @lookup.update_attributes(params[:reference_lookup])
      redirect_to(@lookup)
    else
      render :action => "edit"
    end
  end
	
  ############################################
  ## Helpers
	
	private
	
	def find_reference_lookup
    @lookup = ReferenceLookup.find(params[:id])
  end
  
  def set_tag_container
    @tag_container = @lookup
  end
  
end
