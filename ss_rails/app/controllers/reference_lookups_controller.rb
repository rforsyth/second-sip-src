class ReferenceLookupsController < ApplicationController
	before_filter :initialize_reference_lookups_tabs
	
  def index
    @lookups = ReferenceLookup.all
  end

  def show
    @lookup = ReferenceLookup.find(params[:id])
  end

  def new
    @lookup = ReferenceLookup.new
  end

  def edit
    @lookup = ReferenceLookup.find(params[:id])
  end

  def create
    @lookup = ReferenceLookup.new(params[:reference_lookup])
    if @lookup.save
      redirect_to(@lookup)
    else
      render :action => "new"
    end
  end

  def update
    @lookup = ReferenceLookup.find(params[:id])
    if @lookup.update_attributes(params[:reference_lookup])
      redirect_to(@lookup)
    else
      render :action => "edit"
    end
  end

  def destroy
    @lookup = ReferenceLookup.find(params[:id])
    @lookup.destroy
    redirect_to(reference_lookups_url)
  end
end
