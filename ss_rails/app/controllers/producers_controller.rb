
class ProducersController < ApplicationController
  # GET /producers
  # GET /producers.xml
  def index
    @producers = @producer_class.all
		render :template => 'producers/index'
  end

  # GET /producers/1
  # GET /producers/1.xml
  def show
    @producer = find_by_owner_and_canonical_name_or_id(@producer_class, displayed_taster, params[:id])
		render :template => 'producers/show'
  end

  # GET /producers/new
  # GET /producers/new.xml
  def new
    @producer = @producer_class.new
		render :template => 'producers/new'
  end

  # GET /producers/1/edit
  def edit
    @producer = find_by_owner_and_canonical_name_or_id(@producer_class, displayed_taster, params[:id])
    render :template => 'producers/edit'
  end

  # POST /producers
  # POST /producers.xml
  def create
    @producer = @producer_class.new(params[:producer])
    if @producer.save
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /producers/1
  # PUT /producers/1.xml
  def update
    @producer = find_by_owner_and_canonical_name_or_id(@producer_class, displayed_taster, params[:id])
    if @producer.update_attributes(params[:producer])
      redirect_to([@producer.owner, @producer], :notice => 'Producer was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /producers/1
  # DELETE /producers/1.xml
  def destroy
    @producer = find_by_owner_and_canonical_name_or_id(@producer_class, displayed_taster, params[:id])
    @producer.destroy
    redirect_to(producers_url)
  end
end



