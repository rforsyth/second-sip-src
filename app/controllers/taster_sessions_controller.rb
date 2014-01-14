class TasterSessionsController < ApplicationController
	before_filter :initialize_register_or_login_tabs, :only => [:new]
	#force_ssl :only => [:new, :create]
  
  def new
    @taster_session = TasterSession.new
  end

  def create
    @taster_session = TasterSession.new(params[:taster_session])
    @taster_session.remember_me = true
    if @taster_session.save
      if params[:redir].present?
        redirect_to params[:redir]
      else
        redirect_to(current_taster, :notice => 'Login Successful')
      end
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
