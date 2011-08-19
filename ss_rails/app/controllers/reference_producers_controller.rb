class ReferenceProducersController < ApplicationController
  
  def search
    @producers = @reference_producer_class.all
		render :template => 'reference_producers/search'
  end
  
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    producers = @reference_producer_class.all
    producers.each do |producer|
	    autocomplete.add_suggestion(producer.name, producer.name, producer.id)
    end
    render :json => autocomplete
  end
  
  def index
    @producers = @reference_producer_class.all
		render :template => 'reference_producers/index'
  end

  def show
    @producer = find_by_canonical_name_or_id(@reference_producer_class, params[:id])
		render :template => 'reference_producers/show'
  end

  def new
    @producer = @reference_producer_class.new
		render :template => 'reference_producers/new'
  end

  def edit
    @producer = find_by_canonical_name_or_id(@reference_producer_class, params[:id])
    render :template => 'reference_producers/edit'
  end

  def create
    @producer = @reference_producer_class.new(params[:reference_producer])
    if @producer.save
      redirect_to(@producer)
    else
      render :action => "reference_producers/new"
    end
  end

  def update
    @producer = find_by_canonical_name_or_id(@reference_producer_class, params[:id])
    if @producer.update_attributes(params[:reference_producer])
      redirect_to(@producer) 
    else
      render :action => "reference_producers/edit"
    end
  end

  def destroy
    @producer = find_by_canonical_name_or_id(@reference_producer_class, params[:id])
    @producer.destroy
    redirect_to(reference_producers_url)
  end
end
