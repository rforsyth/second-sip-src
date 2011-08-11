class ReferenceProducersController < ApplicationController
  
  # GET /producers/search
  def search
    @reference_producers = @reference_producer_class.all
		render :template => 'reference_producers/search'
  end
  
  # GET /reference_producers
  # GET /reference_producers.xml
  def index
    @reference_producers = ReferenceProducer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reference_producers }
    end
  end

  # GET /reference_producers/1
  # GET /reference_producers/1.xml
  def show
    @reference_producer = ReferenceProducer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reference_producer }
    end
  end

  # GET /reference_producers/new
  # GET /reference_producers/new.xml
  def new
    @reference_producer = ReferenceProducer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reference_producer }
    end
  end

  # GET /reference_producers/1/edit
  def edit
    @reference_producer = ReferenceProducer.find(params[:id])
  end

  # POST /reference_producers
  # POST /reference_producers.xml
  def create
    @reference_producer = ReferenceProducer.new(params[:reference_producer])

    respond_to do |format|
      if @reference_producer.save
        format.html { redirect_to(@reference_producer, :notice => 'Reference producer was successfully created.') }
        format.xml  { render :xml => @reference_producer, :status => :created, :location => @reference_producer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reference_producer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reference_producers/1
  # PUT /reference_producers/1.xml
  def update
    @reference_producer = ReferenceProducer.find(params[:id])

    respond_to do |format|
      if @reference_producer.update_attributes(params[:reference_producer])
        format.html { redirect_to(@reference_producer, :notice => 'Reference producer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reference_producer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_producers/1
  # DELETE /reference_producers/1.xml
  def destroy
    @reference_producer = ReferenceProducer.find(params[:id])
    @reference_producer.destroy

    respond_to do |format|
      format.html { redirect_to(reference_producers_url) }
      format.xml  { head :ok }
    end
  end
end
