class TasterSessionsController < ApplicationController
  # GET /taster_sessions/new
  def new
    @taster_session = TasterSession.new
  end

  # POST /taster_sessions
  def create
    @taster_session = TasterSession.new(params[:taster_session])
    if @taster_session.save
      redirect_to(current_taster, :notice => 'Login Successful')
    else
      render :action => "new"
    end
  end

  # DELETE /taster_sessions/1
  def destroy
    @taster_session = TasterSession.find
    @taster_session.destroy
    redirect_to(:root, :notice => 'Goodbye!')
  end
end
