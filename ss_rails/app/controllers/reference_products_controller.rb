class ReferenceProductsController < ApplicationController
	before_filter :initialize_reference_products_tabs
  
  # GET /producers/search
  def search
    @reference_products = @reference_product_class.all
		render :template => 'reference_products/search'
  end
  
  # GET /reference_products
  # GET /reference_products.xml
  def index
    @reference_products = ReferenceProduct.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reference_products }
    end
  end

  # GET /reference_products/1
  # GET /reference_products/1.xml
  def show
    @reference_product = ReferenceProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reference_product }
    end
  end

  # GET /reference_products/new
  # GET /reference_products/new.xml
  def new
    @reference_product = ReferenceProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reference_product }
    end
  end

  # GET /reference_products/1/edit
  def edit
    @reference_product = ReferenceProduct.find(params[:id])
  end

  # POST /reference_products
  # POST /reference_products.xml
  def create
    @reference_product = ReferenceProduct.new(params[:reference_product])

    respond_to do |format|
      if @reference_product.save
        format.html { redirect_to(@reference_product, :notice => 'Reference product was successfully created.') }
        format.xml  { render :xml => @reference_product, :status => :created, :location => @reference_product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reference_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reference_products/1
  # PUT /reference_products/1.xml
  def update
    @reference_product = ReferenceProduct.find(params[:id])

    respond_to do |format|
      if @reference_product.update_attributes(params[:reference_product])
        format.html { redirect_to(@reference_product, :notice => 'Reference product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reference_product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_products/1
  # DELETE /reference_products/1.xml
  def destroy
    @reference_product = ReferenceProduct.find(params[:id])
    @reference_product.destroy

    respond_to do |format|
      format.html { redirect_to(reference_products_url) }
      format.xml  { head :ok }
    end
  end
end
