
class ProductsController < ApplicationController
  
  # GET /products/search
  def search
    @products = @product_class.all
		render :template => 'products/search'
  end
  
  # GET /products
  def index
    @products = @product_class.all
		render :template => 'products/index'
  end

  # GET /products/1
  def show
    @product = find_by_owner_and_canonical_name_or_id(@product_class, displayed_taster, params[:id])
		render :template => 'products/show'
  end

  # GET /products/new
  def new
    @product = @product_class.new
		render :template => 'products/new'
  end

  # GET /products/1/edit
  def edit
    @product = find_by_owner_and_canonical_name_or_id(@product_class, displayed_taster, params[:id])
    render :template => 'products/edit'
  end

  # POST /products
  def create
    @product = @product_class.new(params[:product])
    if @product.save
      redirect_to([@product.owner, @product], :notice => 'Product was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /products/1
  def update
    @product = find_by_owner_and_canonical_name_or_id(@product_class, displayed_taster, params[:id])
    if @product.update_attributes(params[:product])
      redirect_to([@product.owner, @product], :notice => 'Product was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /products/1
  def destroy
    @product = find_by_owner_and_canonical_name_or_id(@product_class, displayed_taster, params[:id])
    @product.destroy
    redirect_to(products_url)
  end
end
