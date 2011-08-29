class LookupsController < ApplicationController
	before_filter :initialize_lookups_tabs
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    # lookups = Lookup.where.joins(:lookeds).where(:owner_id => current_taster.id)
    canonical_query = params[:query].try(:canonicalize)
    lookups = Lookup.joins(:lookeds).where(
                     "lookups.canonical_name LIKE ?", "#{canonical_query}%"
                     ).where(
                     :entity_type => params[:entity_type],
                     :lookup_type => params[:lookup_type],
                     :looked => { :owner_id => current_taster.id })
    lookups.each do |lookup|
	    autocomplete.add_suggestion(lookup.name, lookup.name, lookup.id)
    end
    render :json => autocomplete
  end
	
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
