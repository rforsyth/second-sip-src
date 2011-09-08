require 'ui/taggable_controller'
require 'ui/admin_taggable_controller'

class NotesController < ApplicationController
  include UI::TaggableController
  include UI::AdminTaggableController
  
	before_filter :initialize_notes_tabs
  before_filter :find_note, :only => [ :show, :edit, :update,
                  :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  
  def search
    results = @note_class.search(params[:query]).where(
                     :owner_id => displayed_taster.id)
    @notes = page_beverage_results(results)
		render :template => 'notes/search'
  end
  
  def index
    @notes = find_beverage_by_owner_and_tags(@note_class,
               displayed_taster, current_taster, params[:in], params[:ain])
    build_tag_filter(@notes)
    build_admin_tag_filter(@notes)
		render :template => 'notes/index'
  end

  def show
    # todo: enforce visibility here
    @product = @note.product
    @producer = @product.producer
		render :template => 'notes/show'
  end

  def new
    @note = @note_class.new
    @product = @product_class.new  # required to support the product form fields
    @note.tasted_at = Date.today
		render :template => 'notes/new'
  end

  def create
    @note = @note_class.new(params[@note_class.name.underscore])
    @note.set_occasion(params[:occasion_name], current_taster)
    set_product_from_params(@note)
    
    if @note.save
      redirect_to([@note.owner, @note], :notice => 'Note was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
    @product = @note.product
    render :template => 'notes/edit'
  end

  def update
    @note.set_occasion(params[:occasion_name], current_taster)
    set_product_from_params(@note)
    if @note.update_attributes(params[@note_class.name.underscore])
      redirect_to([@note.owner, @note], :notice => 'Note was successfully updated.')
    else
      render :action => "edit"
    end
  end
	
  ############################################
  ## Helpers
	
	private
	
	def find_note
    @note = @note_class.find(params[:id])
  end
  
  def set_tag_container
    @tag_container = @note
  end
  
  def set_product_from_params(note)
    if params[:product_name].present?
      note.product = find_product_by_canonical_names(displayed_taster,
                       params[:producer_name].canonicalize, params[:product_name].canonicalize)
    end
    if note.product.present?
      note.product.attributes = params[@product_class.name.underscore]
    else
      note.product = @product_class.new(params[@product_class.name.underscore])
      note.product.name = params[:product_name]
    end
    note.product.set_lookup_properties(params, displayed_taster, @producer_class)
    note.product.save
  end
  
  
end
