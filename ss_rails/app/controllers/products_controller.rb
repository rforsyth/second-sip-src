require 'ui/taggable_controller'
require 'ui/admin_taggable_controller'

class ProductsController < ApplicationController
  include UI::TaggableController
  include UI::AdminTaggableController
  
	before_filter :initialize_products_tabs
  before_filter :find_product, :only => [ :show, :edit, :update,
                  :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  
  def search
    @products = @product_class.search(params[:query]).where(
                     :owner_id => displayed_taster.id)
		render :template => 'products/search'
	end
  
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    
    canonical_producer_name = params[:producer_name].try(:canonicalize)
    canonical_query = params[:query].try(:canonicalize)
    products = @product_class.joins(:producer).where(
                     :owner_id => current_taster.id,
                     :producers => { :owner_id => current_taster.id,
                                     :canonical_name => canonical_producer_name }
                     ).where("products.canonical_name LIKE ?", "#{canonical_query}%")

    products.each do |product|
	    autocomplete.add_suggestion(product.name, product.name, product.id)
    end
    render :json => autocomplete
  end
  
  def index
    @products = polymorphic_find_by_owner_and_tags(@product_class, displayed_taster, params[:in], params[:ain])
    build_tag_filter(@products)
    build_admin_tag_filter(@products)
		render :template => 'products/index'
  end

  def show
    # todo: enforce visibility here
    @producer = @product.producer
		render :template => 'products/show'
  end

  def new
    @product = @product_class.new
		render :template => 'products/new'
  end

  def create
    @product = @product_class.new(params[@product_class.name.underscore])
    @product.set_lookup_properties(params, current_taster, @producer_class)
      
    if @product.save
      redirect_to([@product.owner, @product], :notice => 'Product was successfully created.')
    else
      render :action => "products/new"
    end
  end

  def edit
    render :template => 'products/edit'
  end

  def update
    @product.set_lookup_properties(params, displayed_taster, @producer_class)
    
    if @product.update_attributes(params[@product_class.name.underscore])
      redirect_to([@product.owner, @product], :notice => 'Product was successfully updated.')
    else
      render :action => "products/edit"
    end
  end
	
  ############################################
  ## Helpers
  
  private
  
  def find_product
    @product = find_product_by_canonical_name_or_id(displayed_taster, params[:id])
  end
  
  def set_tag_container
    @tag_container = @product
  end
  
end
