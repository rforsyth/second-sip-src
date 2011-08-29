
class ProducersController < ApplicationController
	before_filter :initialize_producers_tabs
  
  def search
    @producers = @producer_class.all
		render :template => 'producers/search'
  end
  
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    canonical_query = params[:query].try(:canonicalize)
    producers = @producer_class.find_all_by_owner_id(current_taster.id,
                  :conditions => ["producers.canonical_name LIKE ?", "#{canonical_query}%"] )
    
    producers.each do |producer|
	    autocomplete.add_suggestion(producer.name, producer.name, producer.id)
    end
    render :json => autocomplete
  end
  
  def index
    @producers = @producer_class.find_all_by_owner_id(displayed_taster.id)
		render :template => 'producers/index'
  end

  def show
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
		render :template => 'producers/show'
  end

  def new
    @producer = @producer_class.new
		render :template => 'producers/new'
  end

  def edit
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    render :template => 'producers/edit'
  end

  def create
    @producer = @producer_class.new(params[@producer_class.name.underscore])
    if @producer.save
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully created.')
    else
      render :action => "producers/new"
    end
  end

  def update
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    if @producer.update_attributes(params[@producer_class.name.underscore])
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully updated.')
    else
      render :action => "producers/edit"
    end
  end

  def destroy
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    @producer.destroy
    redirect_to(producers_url)
  end
  
  private
  
end



