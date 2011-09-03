require 'ui/admin_taggable_controller'

class ReferenceLookupsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_lookup, :only => [ :show, :edit, :update,
                                                   :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
	before_filter :initialize_reference_lookups_tabs
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    canonical_query = params[:query].try(:canonicalize)
    lookups = ReferenceLookup.find_by_sql(
      ["SELECT DISTINCT reference_lookups.* FROM reference_lookups 
        INNER JOIN reference_looked ON reference_lookups.id = reference_looked.reference_lookup_id
        WHERE reference_lookups.canonical_name LIKE ?
          AND reference_lookups.entity_type = ?
          AND reference_lookups.lookup_type = ?
          AND reference_looked.owner_id = ?",
        "#{canonical_query}%", params[:entity_type],
        params[:lookup_type].to_i, current_taster.id])
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
