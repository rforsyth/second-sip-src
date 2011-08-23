class AdminTagsController < ApplicationController
	before_filter :initialize_admin_tags_tabs
	
  def index
    @admin_tags = AdminTag.all
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
