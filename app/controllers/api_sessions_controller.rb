class ApiSessionsController < ApplicationController
  
  def new
    
    puts 'inside ApiSessionsController-> new'
    
    @taster_session = TasterSession.new
  end

  def create
    
    puts 'inside ApiSessionsController-> create'
    
    @taster_session = TasterSession.new(params[:taster_session])
    @taster_session.remember_me = true
    if @taster_session.save
      puts 'created session'
#      render :json => "{\"balance\":1000.21,\"num\":100,\"nickname\":null,\"is_vip\":true,\"name\":\"foo\"}"
    
      #results = Api::QueryResults.new(:newest)
      
      api_taster = current_taster.api_copy
      
      puts api_taster.inspect
      
      
      render :json => api_taster
    else
      puts 'failed to create session'
      # return failure
    end
  end

  def destroy
    @taster_session = TasterSession.find
    @taster_session.destroy if @taster_session
    # return success
  end
end
