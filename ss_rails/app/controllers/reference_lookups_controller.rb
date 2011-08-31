require 'ui/admin_taggable_controller'

class ReferenceLookupsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_lookup, :only => [ :show, :edit, :update,
                                                   :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
	before_filter :initialize_reference_lookups_tabs
	
  def index
    @lookups = ReferenceLookup.all
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
