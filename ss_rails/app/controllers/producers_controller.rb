require 'ui/taggable_controller'
require 'ui/admin_taggable_controller'

class ProducersController < ApplicationController
  include UI::TaggableController
  include UI::AdminTaggableController
  
	before_filter :initialize_producers_tabs
  before_filter :find_producer, :only => [ :show, :edit, :update,
                  :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_tag, :remove_tag, :add_admin_tag, :remove_admin_tag ]
  
  def search
    @producers = @producer_class.search(params[:query]).where(
                     :owner_id => displayed_taster.id)
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
    @producers = polymorphic_find_by_owner_and_tags(@producer_class, displayed_taster, params[:in], params[:ain])
    build_tag_filter(@producers)
    build_admin_tag_filter(@producers)
		render :template => 'producers/index'
  end

  def show
		render :template => 'producers/show'
  end

  def new
    @producer = @producer_class.new
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
	
	def find_producer
    @producer = find_producer_by_canonical_name_or_id(displayed_taster, params[:id])
  end
  
  def set_tag_container
    @tag_container = @producer
  end
  
end



