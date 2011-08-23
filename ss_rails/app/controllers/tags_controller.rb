class TagsController < ApplicationController
	before_filter :initialize_tags_tabs
	
  def index
    @tags = Tag.all
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
