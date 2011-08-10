class TastersController < ApplicationController
  # GET /tasters
  # GET /tasters.xml
  def index
    @tasters = Taster.all
  end

  # GET /tasters/1
  # GET /tasters/1.xml
  def show
    @taster = Taster.find_by_username(params[:id])
  end

  # GET /tasters/new
  # GET /tasters/new.xml
  def new
    @taster = Taster.new
  end

  # GET /tasters/1/edit
  def edit
    @taster = Taster.find_by_username(params[:id])
  end

  # POST /tasters
  # POST /tasters.xml
  def create
    @taster = Taster.new(params[:taster])
    if @taster.save
      redirect_to(@taster, :notice => 'Taster was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /tasters/1
  # PUT /tasters/1.xml
  def update
    @taster = Taster.find_by_username(params[:id])

    if @taster.update_attributes(params[:taster])
      redirect_to(@taster, :notice => 'Taster was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /tasters/1
  # DELETE /tasters/1.xml
  def destroy
    @taster = Taster.find_by_username(params[:id])
    @taster.destroy
    redirect_to(tasters_url)
  end
end
