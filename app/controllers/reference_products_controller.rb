require 'ui/admin_taggable_controller'

class ReferenceProductsController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_product, :only => [ :show, :edit, :update,
                                                    :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
  before_filter :require_editor
  
  def search
    results = @reference_product_class.search(params[:query])
    @products = page_beverage_results(results)
		render :template => 'reference_products/search'
  end
  
  def index
    @products = find_reference_beverage_by_admin_tags(@reference_product_class, current_taster, params[:ain])
    build_admin_tag_filter(@products)
		render :template => 'reference_products/index'
  end

  def show
		render :template => 'reference_products/show'
  end

  def new
    @product = @reference_product_class.new
    if params[:promote].present? && current_taster.is?(:editor)
      promote_from = @product_class.find(params[:promote])
      if promote_from.present?
        @existing_product = @reference_product_class.find_by_canonical_name(
          promote_from.canonical_name,
          :conditions => {:reference_producer_canonical_name => promote_from.producer_canonical_name})
        if @existing_product.present?
          return render :template => 'reference_products/already_exists'
        end
        @product.copy_from_user_product(promote_from) 
      end
    end
		render :template => 'reference_products/new'
  end

  def create
    @product = @reference_product_class.new(params[@reference_product_class.name.underscore])
    @product.set_lookup_properties(params, @reference_producer_class)
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
    @product.set_lookup_properties(params, @reference_producer_class)
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
