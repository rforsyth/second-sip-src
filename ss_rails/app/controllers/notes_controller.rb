
class NotesController < ApplicationController
	before_filter :initialize_notes_tabs
  
  def search
    @notes = @note_class.find_all_by_owner_id(displayed_taster.id)
		render :template => 'notes/search'
  end
  
  def index
    @notes = @note_class.find_all_by_owner_id(displayed_taster.id)
		render :template => 'notes/index'
  end

  def show
    @note = @note_class.find(params[:id])
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

  def edit
    @note = @note_class.find(params[:id])
    @product = @note.product
    render :template => 'notes/edit'
  end

  def create
    @note = @note_class.new(params[@note_class.name.underscore])
    set_product_from_params(@note)
    
    if @note.save
      redirect_to([@note.owner, @note], :notice => 'Note was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @note = @note_class.find(params[:id])
    set_product_from_params(@note)
    
    if @note.update_attributes(params[@note_class.name.underscore])
      redirect_to([@note.owner, @note], :notice => 'Note was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  private
  
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
