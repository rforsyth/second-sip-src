require 'ui/taggable_controller'
require 'ui/admin_taggable_controller'

class NotesController < ApplicationController
  include UI::TaggableController
  include UI::AdminTaggableController
  
	before_filter :initialize_notes_tabs
  before_filter :find_note, :only => [ :show, :edit, :update, :delete, :destroy,
                  :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :require_admin, :only => [:add_admin_tag, :remove_admin_tag]
  before_filter :require_viewing_own_data, :only => [:new, :create, :edit, :update, :delete, :destroy]
  before_filter :require_visibility, :only => [:show]
  
  def search
    @notes = search_beverage_by_owner(@note_class, params[:query],
                                      displayed_taster, current_taster)
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
    @product = @note.product
    @show_product = test_visibility(@product, current_taster)
    @producer = @product.producer
    @show_producer = test_visibility(@producer, current_taster)
    if @product.kind_of?(Beer)
      display_reference_lookup(@product.style.try(:canonical_name), "ReferenceBeer", Enums::LookupType::STYLE)
    end
		render :template => 'notes/show'
  end

  def new
    @note = @note_class.new
    initialize_new_note_form
		render :template => 'notes/new'
  end

  def create
    @note = @note_class.new(params[@note_class.name.underscore])
    if !validate_producer_and_product_name
      initialize_new_note_form
      return render :action => "notes/edit"
    end
    @note.set_occasion(params[:occasion_name], current_taster)
    set_product_from_params(@note)
    
    if @note.save
      remember_score_type(@note)
      remember_visibility(@note)
      redirect_to([@note.owner, @note], :notice => 'Note was successfully created.')
    else
      initialize_new_note_form
      render :action => "notes/new"
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
      remember_score_type(@note)
      remember_visibility(@note)
      redirect_to([@note.owner, @note], :notice => 'Note was successfully updated.')
    else
      @product = @note.product
      render :action => "notes/edit"
    end
  end
  
  def delete
    render :template => 'notes/delete'
  end
  
  def destroy
    @note.delete
    redirect_to polymorphic_path([displayed_taster, @note_class])
  end
	
  ############################################
  ## Helpers
	
	private
	
	def require_visibility
	  require_visibility_helper(@note)
	end
	
	def initialize_new_note_form
	  @product = @note.product
    @product ||= @product_class.new  # required to support the product form fields
    @note.tasted_at ||= Date.today
    @note.visibility ||= (cookies[:last_visibility] || Enums::Visibility::PUBLIC)
  end
  
  def validate_producer_and_product_name
    if !params[:producer_name].present?
      @note.errors.add(:producer, "#{@producer_class.name} cannot be blank")
    end
    if !params[:product_name].present?
      @note.errors.add(:product, "#{@product_class.name} cannot be blank")
    end
    if @note.errors.any?
      @show_error_messages_only = true
      return false
    else
      return true
    end
  end
	
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
      note.product.visibility = note.visibility
    end
    note.product.set_lookup_properties(params, displayed_taster, @producer_class)
    note.product.save
    if note.product.present?
      note.product_name = note.product.name 
      note.producer_name = note.product.producer.name if note.product.producer.present?
    end
  end
  
  def remember_score_type(note)
    return if !note.score_type.present?
	  if note.kind_of?(BeerNote)
	    cookies[:beer_note_score_type] = note.score_type
    else
	    cookies[:wine_note_score_type] = note.score_type
    end
  end
  
end
