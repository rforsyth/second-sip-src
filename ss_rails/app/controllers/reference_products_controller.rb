class ReferenceProductsController < ApplicationController
  
  def search
    @products = @reference_product_class.all
		render :template => 'reference_products/search'
  end
  
  def index
    @products = @reference_product_class.all
		render :template => 'reference_products/index'
  end

  def show
    @product = find_reference_product_by_canonical_name_or_id(params[:id])
		render :template => 'reference_products/show'
  end

  def new
    @product = @reference_product_class.new
		render :template => 'reference_products/new'
  end

  def edit
    @product = find_reference_product_by_canonical_name_or_id(params[:id])
    render :template => 'reference_products/edit'
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

  def update
    @product = find_reference_product_by_canonical_name_or_id(params[:id])
    if @product.update_attributes(params[@reference_product_class.name.underscore])
      redirect_to(@product)
    else
      render :action => "reference_products/edit"
    end
  end

  def destroy
    @product = find_reference_product_by_canonical_name_or_id(params[:id])
    @product.destroy
    redirect_to(reference_products_url)
  end
end
