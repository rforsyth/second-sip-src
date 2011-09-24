require 'ui/admin_taggable_controller'

class ReferenceProducersController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_reference_producer, :only => [ :show, :edit, :update,
                                                     :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
  before_filter :require_admin
  
  def search
    results = @reference_producer_class.search(params[:query])
    @producers = page_beverage_results(results)
		render :template => 'reference_producers/search'
  end
  
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    
    canonical_query = params[:query].try(:canonicalize)
    reference_producers = @reference_producer_class.where(
                  ["reference_producers.canonical_name LIKE ?", "%#{canonical_query}%"]
                  ).limit(MAX_AUTOCOMPLETE_RESULTS)
    reference_producers.each do |reference_producer|
	    autocomplete.add_suggestion(reference_producer.name, reference_producer.name, reference_producer.id)
    end
    render :json => autocomplete
  end
  
  def index
    @producers = find_reference_beverage_by_admin_tags(@reference_producer_class, current_taster, params[:ain])
    build_admin_tag_filter(@producers)
		render :template => 'reference_producers/index'
  end

  def show
    results = @reference_product_class.find_by_sql(
      ["SELECT DISTINCT reference_products.* FROM reference_products
        INNER JOIN reference_producers ON reference_products.reference_producer_id = reference_producers.id
        WHERE reference_producers.id = ?
        ORDER BY created_at DESC
        LIMIT ?",
        @producer.id, MAX_BEVERAGE_RESULTS])
    @products = page_beverage_results(results)
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
