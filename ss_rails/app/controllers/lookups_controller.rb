require 'ui/admin_taggable_controller'

class LookupsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_lookup, :only => [ :show, :edit, :update,
                                         :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
	before_filter :initialize_lookups_tabs
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    canonical_query = params[:query].try(:canonicalize)
    lookups = Lookup.joins(:lookeds).where(
                     "lookups.canonical_name LIKE ?", "#{canonical_query}%"
                     ).where(
                     :entity_type => params[:entity_type],
                     :lookup_type => params[:lookup_type],
                     :looked => { :owner_id => current_taster.id })
    lookups.each do |lookup|
	    autocomplete.add_suggestion(lookup.name, lookup.name, lookup.id)
    end
    render :json => autocomplete
  end
	
  def index
    @lookups = Lookup.all
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
