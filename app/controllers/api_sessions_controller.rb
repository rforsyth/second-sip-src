class ApiSessionsController < ApiController
  
  def new
    @taster_session = TasterSession.new
  end

  def create
    @taster_session = TasterSession.new(params[:taster_session])
    @taster_session.remember_me = true
    if @taster_session.save
      api_taster = current_taster.api_copy
      render :json => api_taster
    else
      render_login_json_error(:login, @taster_session)
    end
  end

  def destroy
    @taster_session = TasterSession.find
    @taster_session.destroy if @taster_session
    # return success
  end
end
