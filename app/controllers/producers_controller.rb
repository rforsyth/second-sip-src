require 'ui/taggable_controller'
require 'ui/admin_taggable_controller'

class ProducersController < ApplicationController
  include UI::TaggableController
  include UI::AdminTaggableController
  
	before_filter :initialize_producers_tabs
  before_filter :find_producer, :only => [ :show, :edit, :update, :delete, :destroy,
                  :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :require_admin, :only => [:add_admin_tag, :remove_admin_tag]
  before_filter :require_viewing_own_data, :only => [:new, :create, :edit, :update, :ajax_details, :delete, :destroy]
  before_filter :require_visibility, :only => [:show]
  before_filter :require_displayed_taster
  
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
      results = find_producer_notes(@producer, MAX_BEVERAGE_RESULTS)
      @notes = page_beverage_results(results)
    else
      results = find_producer_products(@producer, MAX_BEVERAGE_RESULTS)
      @products = page_beverage_results(results)
    end
		render :template => 'producers/show'
  end

  def new
    @producer = @producer_class.new
    @producer.visibility = (cookies[:last_visibility] || Enums::Visibility::PUBLIC)
		render :template => 'producers/new'
  end

  def create
    @producer = @producer_class.new(params[@producer_class.name.underscore])
    if @producer.save
      remember_visibility(@producer)
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully created.')
    else
      render :template => "producers/new"
    end
  end

  def edit
    render :template => 'producers/edit'
  end

  def update
    if @producer.update_attributes(params[@producer_class.name.underscore])
      remember_visibility(@producer)
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully updated.')
    else
      render :template => "producers/edit"
    end
  end
  
  def delete
    render :template => 'producers/delete'
  end
  
  def destroy
    @producer.destroy
    redirect_to polymorphic_path([displayed_taster, @producer_class])
  end
	
  ############################################
  ## Helpers
	
	private
	
	def require_visibility
	  require_visibility_helper(@producer)
	end
	
	def find_producer
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
    if !@producer.present?
      flash[:notice] = "Unable to find that #{@producer_class.name} in our database" 
      render :template => 'errors/message', :layout => 'single_column', :status => 404
      return false
    end
  end
  
  def set_tag_container
    @tag_container = @producer
  end
  
end



