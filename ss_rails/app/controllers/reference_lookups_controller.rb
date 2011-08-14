class ReferenceLookupsController < ApplicationController
	before_filter :initialize_reference_lookups_tabs
	
  # GET /reference_lookups
  # GET /reference_lookups.xml
  def index
    @reference_lookups = ReferenceLookup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reference_lookups }
    end
  end

  # GET /reference_lookups/1
  # GET /reference_lookups/1.xml
  def show
    @reference_lookup = ReferenceLookup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reference_lookup }
    end
  end

  # GET /reference_lookups/new
  # GET /reference_lookups/new.xml
  def new
    @reference_lookup = ReferenceLookup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reference_lookup }
    end
  end

  # GET /reference_lookups/1/edit
  def edit
    @reference_lookup = ReferenceLookup.find(params[:id])
  end

  # POST /reference_lookups
  # POST /reference_lookups.xml
  def create
    @reference_lookup = ReferenceLookup.new(params[:reference_lookup])

    respond_to do |format|
      if @reference_lookup.save
        format.html { redirect_to(@reference_lookup, :notice => 'Reference lookup was successfully created.') }
        format.xml  { render :xml => @reference_lookup, :status => :created, :location => @reference_lookup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reference_lookup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reference_lookups/1
  # PUT /reference_lookups/1.xml
  def update
    @reference_lookup = ReferenceLookup.find(params[:id])

    respond_to do |format|
      if @reference_lookup.update_attributes(params[:reference_lookup])
        format.html { redirect_to(@reference_lookup, :notice => 'Reference lookup was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reference_lookup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_lookups/1
  # DELETE /reference_lookups/1.xml
  def destroy
    @reference_lookup = ReferenceLookup.find(params[:id])
    @reference_lookup.destroy

    respond_to do |format|
      format.html { redirect_to(reference_lookups_url) }
      format.xml  { head :ok }
    end
  end
end
