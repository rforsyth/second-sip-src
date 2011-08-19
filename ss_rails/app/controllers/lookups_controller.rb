class LookupsController < ApplicationController
	before_filter :initialize_lookups_tabs
	
  def index
    @lookups = Lookup.all
  end

  def show
    @lookup = Lookup.find(params[:id])
  end

  def new
    @lookup = Lookup.new
  end

  def edit
    @lookup = Lookup.find(params[:id])
  end

  def create
    @lookup = Lookup.new(params[:lookup])
    if @lookup.save
      redirect_to(@lookup)
    else
      render :action => "new"
    end
  end

  def update
    @lookup = Lookup.find(params[:id])
    if @lookup.update_attributes(params[:lookup])
      redirect_to(@lookup)
    else
      render :action => "edit"
    end
  end

  def destroy
    @lookup = Lookup.find(params[:id])
    @lookup.destroy
    redirect_to(lookups_url)
  end
end
