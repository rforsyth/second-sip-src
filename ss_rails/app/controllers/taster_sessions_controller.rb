class TasterSessionsController < ApplicationController
	before_filter :initialize_register_or_login_tabs, :only => [:new]
  
  def new
    @taster_session = TasterSession.new
  end

  def create
    @taster_session = TasterSession.new(params[:taster_session])
    @taster_session.remember_me = true
    if @taster_session.save
      redirect_to(current_taster, :notice => 'Login Successful')
    else
      render :action => "new"
    end
  end

  def destroy
    @taster_session = TasterSession.find
    @taster_session.destroy if @taster_session
    redirect_to(:root, :notice => 'Goodbye!')
  end
end
