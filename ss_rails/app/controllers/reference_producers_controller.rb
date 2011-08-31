require 'ui/admin_taggable_controller'

class ReferenceProducersController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_producer, :only => [ :show, :edit, :update,
                                                     :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
  
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
		render :template => 'reference_producers/show'
  end

  def new
    @producer = @reference_producer_class.new
		render :template => 'reference_producers/new'
  end

  def create
    @producer = @reference_producer_class.new(params[@reference_producer_class.name.underscore])
    if @producer.save
      redirect_to(@producer)
    else
      render :action => "reference_producers/new"
    end
  end

  def edit
    @producer = find_reference_producer_by_canonical_name_or_id(params[:id])
    render :template => 'reference_producers/edit'
  end

  def update
    if @producer.update_attributes(params[@reference_producer_class.name.underscore])
      redirect_to(@producer) 
    else
      render :action => "reference_producers/edit"
    end
  end
	
  ############################################
  ## Helpers
	
	private
	
	def find_reference_producer
    @producer = find_reference_producer_by_canonical_name_or_id(params[:id])
  end
  
  def set_tag_container
    @tag_container = @producer
  end
  
end