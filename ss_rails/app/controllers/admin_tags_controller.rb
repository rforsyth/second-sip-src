class AdminTagsController < ApplicationController
	before_filter :initialize_admin_tags_tabs
	
  def autocomplete
    autocomplete = Ajax::Autocomplete.new(params[:query])
    tagified_query = params[:query].try(:tagify)
    tags = AdminTag.find_by_sql(
      ["SELECT DISTINCT admin_tags.* FROM admin_tags 
        INNER JOIN admin_tagged ON admin_tags.id = admin_tagged.admin_tag_id
        WHERE admin_tags.name LIKE ?
          AND admin_tags.entity_type = ?
         AND admin_tagged.owner_id = ?
        LIMIT ?",
        "#{tagified_query}%", params[:entity_type], current_taster.id, MAX_AUTOCOMPLETE_RESULTS])
    tags.each do |tag|
	    autocomplete.add_suggestion(tag.name, tag.name, tag.id)
    end
    render :json => autocomplete
  end
  
  def index
    results = AdminTag.limit(MAX_BEVERAGE_RESULTS)
    @admin_tags = page_beverage_results(results)
  end

  def show
    @admin_tag = find_by_name_or_id(AdminTag, params[:id])
  end

  def new
    @admin_tag = AdminTag.new
  end

  def edit
    @admin_tag = find_by_name_or_id(AdminTag, params[:id])
  end

  def create
    @admin_tag = AdminTag.new(params[:admin_tag])
    if @admin_tag.save
      redirect_to(@admin_tag)
    else
      render :action => "new"
    end
  end

  def update
    @admin_tag = find_by_name_or_id(AdminTag, params[:id])
    if @admin_tag.update_attributes(params[:admin_tag])
      redirect_to(@admin_tag)
    else
      render :action => "edit"
    end
  end

  def destroy
    @admin_tag = find_by_name_or_id(AdminTag, params[:id])
    @admin_tag.destroy
    redirect_to(tags_url)
  end
end
