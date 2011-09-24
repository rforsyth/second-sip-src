class TagsController < ApplicationController
	before_filter :initialize_tags_tabs
  before_filter :require_admin, :except => [:autocomplete]
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    tagified_query = params[:query].try(:tagify)
    tags = Tag.find_by_sql(
      ["SELECT DISTINCT tags.* FROM tags 
        INNER JOIN tagged ON tags.id = tagged.tag_id
        WHERE tags.name LIKE ?
          AND tags.entity_type = ?
          AND tagged.owner_id = ?
        LIMIT ?",
        "#{tagified_query}%", params[:entity_type], current_taster.id, MAX_AUTOCOMPLETE_RESULTS])
    tags.each do |tag|
	    autocomplete.add_suggestion(tag.name, tag.name, tag.id)
    end
    render :json => autocomplete
  end
	
  def index
    results = Tag.limit(MAX_BEVERAGE_RESULTS)
    @tags = page_beverage_results(results)
  end

  def show
    @tag = find_by_name_or_id(Tag, params[:id])
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = find_by_name_or_id(Tag, params[:id])
  end

  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      redirect_to(@tag)
    else
      render :action => "new"
    end
  end

  def update
    @tag = find_by_name_or_id(Tag, params[:id])
    if @tag.update_attributes(params[:tag])
      redirect_to(@tag)
    else
      render :action => "edit"
    end
  end

  def destroy
    @tag = find_by_name_or_id(Tag, params[:id])
    @tag.destroy
    redirect_to(tags_url)
  end
end
