class AdminTagsController < ApplicationController
	before_filter :initialize_admin_tags_tabs
	
  # GET /admin_tags
  # GET /admin_tags.xml
  def index
    @admin_tags = AdminTag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_tags }
    end
  end

  # GET /admin_tags/1
  # GET /admin_tags/1.xml
  def show
    @admin_tag = AdminTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_tag }
    end
  end

  # GET /admin_tags/new
  # GET /admin_tags/new.xml
  def new
    @admin_tag = AdminTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_tag }
    end
  end

  # GET /admin_tags/1/edit
  def edit
    @admin_tag = AdminTag.find(params[:id])
  end

  # POST /admin_tags
  # POST /admin_tags.xml
  def create
    @admin_tag = AdminTag.new(params[:admin_tag])

    respond_to do |format|
      if @admin_tag.save
        format.html { redirect_to(@admin_tag, :notice => 'Admin tag was successfully created.') }
        format.xml  { render :xml => @admin_tag, :status => :created, :location => @admin_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_tags/1
  # PUT /admin_tags/1.xml
  def update
    @admin_tag = AdminTag.find(params[:id])

    respond_to do |format|
      if @admin_tag.update_attributes(params[:admin_tag])
        format.html { redirect_to(@admin_tag, :notice => 'Admin tag was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_tags/1
  # DELETE /admin_tags/1.xml
  def destroy
    @admin_tag = AdminTag.find(params[:id])
    @admin_tag.destroy

    respond_to do |format|
      format.html { redirect_to(admin_tags_url) }
      format.xml  { head :ok }
    end
  end
end
