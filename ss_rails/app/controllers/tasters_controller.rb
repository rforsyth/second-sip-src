class TastersController < ApplicationController
  # GET /tasters
  # GET /tasters.xml
  def index
    @tasters = Taster.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasters }
    end
  end

  # GET /tasters/1
  # GET /tasters/1.xml
  def show
    @taster = Taster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @taster }
    end
  end

  # GET /tasters/new
  # GET /tasters/new.xml
  def new
    @taster = Taster.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @taster }
    end
  end

  # GET /tasters/1/edit
  def edit
    @taster = Taster.find(params[:id])
  end

  # POST /tasters
  # POST /tasters.xml
  def create
    @taster = Taster.new(params[:taster])

    respond_to do |format|
      if @taster.save
        format.html { redirect_to(@taster, :notice => 'Taster was successfully created.') }
        format.xml  { render :xml => @taster, :status => :created, :location => @taster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @taster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasters/1
  # PUT /tasters/1.xml
  def update
    @taster = Taster.find(params[:id])

    respond_to do |format|
      if @taster.update_attributes(params[:taster])
        format.html { redirect_to(@taster, :notice => 'Taster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @taster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasters/1
  # DELETE /tasters/1.xml
  def destroy
    @taster = Taster.find(params[:id])
    @taster.destroy

    respond_to do |format|
      format.html { redirect_to(tasters_url) }
      format.xml  { head :ok }
    end
  end
end
