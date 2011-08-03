class TasterSessionsController < ApplicationController
  # GET /taster_sessions/new
  # GET /taster_sessions/new.xml
  def new
    @taster_session = TasterSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @taster_session }
    end
  end

  # POST /taster_sessions
  # POST /taster_sessions.xml
  def create
    @taster_session = TasterSession.new(params[:taster_session])

    respond_to do |format|
      if @taster_session.save
        format.html { redirect_to(:tasters, :notice => 'Login Successful') }
        format.xml  { render :xml => @taster_session, :status => :created, :location => @taster_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @taster_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taster_sessions/1
  # DELETE /taster_sessions/1.xml
  def destroy
    @taster_session = TasterSession.find
    @taster_session.destroy

    respond_to do |format|
      format.html { redirect_to(:tasters, :notice => 'Goodbye!') }
      format.xml  { head :ok }
    end
  end
end
