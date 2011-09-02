require 'ui/admin_taggable_controller'

class ReferenceProductsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_product, :only => [ :show, :edit, :update,
                                                    :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
  
  def search
    @products = @reference_product_class.search(params[:query])
		render :template => 'reference_products/search'
  end
  
  def index
    @products = @reference_product_class.all
		render :template => 'reference_products/index'
  end

  def show
		render :template => 'reference_products/show'
  end

  def new
    @product = @reference_product_class.new
		render :template => 'reference_products/new'
  end

  def create
    @product = @reference_product_class.new(params[@reference_product_class.name.underscore])
    @product.reference_producer = @reference_producer_class.find_by_canonical_name(
                                    params[:reference_producer_name].try(:canonicalize))
    if @product.save
      redirect_to(@product)
    else
      render :action => "reference_products/new"
    end
  end

  def edit
    render :template => 'reference_products/edit'
  end

  def update
    if @product.update_attributes(params[@reference_product_class.name.underscore])
      redirect_to(@product)
    else
      render :action => "reference_products/edit"
    end
  end
	
  ############################################
  ## Helpers
	
	private
	
	def find_reference_product
    @product = find_reference_product_by_canonical_name_or_id(params[:id])
  end
  
  def set_tag_container
    @tag_container = @product
  end
  
end
