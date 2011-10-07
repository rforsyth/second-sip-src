require 'ui/taggable_controller'
require 'ui/admin_taggable_controller'

class ProducersController < ApplicationController
  include UI::TaggableController
  include UI::AdminTaggableController
  
	before_filter :initialize_producers_tabs
  before_filter :find_producer, :only => [ :show, :edit, :update,
                  :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :require_admin, :only => [:add_admin_tag, :remove_admin_tag]
  before_filter :require_viewing_own_data, :only => [:new, :create, :edit, :update, :ajax_details]
  before_filter :require_visibility, :only => [:show]
  
  def search
    @producers = search_beverage_by_owner(@producer_class, params[:query],
                                          displayed_taster, current_taster)
		render :template => 'producers/search'
  end
  
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    canonical_query = params[:query].try(:canonicalize)
    producers = @producer_class.where(:owner_id => current_taster.id,
                     ).where("producers.canonical_name LIKE ?", "%#{canonical_query}%"
                     ).limit(MAX_AUTOCOMPLETE_RESULTS)
    producers.each do |producer|
	    autocomplete.add_suggestion(producer.name, producer.name, producer.id)
    end
    render :json => autocomplete
  end
  
  def ajax_details
    producer = find_producer_by_canonical_name_or_id(
                 displayed_taster, params[:name].try(:canonicalize))
    producer ||= @producer_class.new
    render :json => producer.simple_copy
  end
  
  def index
    @producers = find_beverage_by_owner_and_tags(@producer_class,
                   displayed_taster, current_taster, params[:in], params[:ain])
    build_tag_filter(@producers)
    build_admin_tag_filter(@producers)
		render :template => 'producers/index'
  end

  def show
    if params[:tab] == 'notes'
      results = @note_class.find_by_sql(
        ["SELECT DISTINCT notes.* FROM notes 
          INNER JOIN products ON notes.product_id = products.id
          INNER JOIN producers ON products.producer_id = producers.id
          WHERE producers.id = ?
            AND #{known_owner_visibility_clause(@note_class, displayed_taster, current_taster)}
          ORDER BY created_at DESC
          LIMIT ?",
          @producer.id, MAX_BEVERAGE_RESULTS])
      @notes = page_beverage_results(results)
    else
      results = @product_class.find_by_sql(
        ["SELECT DISTINCT products.* FROM products
          INNER JOIN producers ON products.producer_id = producers.id
          WHERE producers.id = ?
            AND #{known_owner_visibility_clause(@product_class, displayed_taster, current_taster)}
          ORDER BY created_at DESC
          LIMIT ?",
          @producer.id, MAX_BEVERAGE_RESULTS])
      @products = page_beverage_results(results)
    end
		render :template => 'producers/show'
  end

  def new
    @producer = @producer_class.new
    @producer.visibility = Enums::Visibility::PUBLIC
		render :template => 'producers/new'
  end

  def create
    @producer = @producer_class.new(params[@producer_class.name.underscore])
    if @producer.save
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully created.')
    else
      render :action => "producers/new"
    end
  end

  def edit
    render :template => 'producers/edit'
  end

  def update
    if @producer.update_attributes(params[@producer_class.name.underscore])
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully updated.')
    else
      render :action => "producers/edit"
    end
  end
	
  ############################################
  ## Helpers
	
	private
	
	def require_visibility
	  require_visibility_helper(@producer)
	end
	
	def find_producer
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
  end
  
  def set_tag_container
    @tag_container = @producer
  end
  
end



