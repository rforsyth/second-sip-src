class PasswordResetsController < ApplicationController
  before_filter :load_taster_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_taster
	before_filter :initialize_register_or_login_tabs

  def new   
  end  
  
  def edit
  end
  
  def create  
    @taster = Taster.find_by_email(params[:email])  
    if @taster  
      @taster.deliver_password_reset_instructions!
      render :action => 'success', :layout => 'single_column'
    else  
      flash[:notice] = "No taster was found with that email address"  
      render :action => :new  
    end  
  end  
  
  def update  
    @taster.password = params[:taster][:password]  
    @taster.password_confirmation = params[:taster][:password_confirmation]  
    if @taster.save  
      flash[:notice] = "Password successfully updated"  
      redirect_to taster_url(@taster)  
    else  
      render :action => :edit  
    end  
  end  
  
  private
  
  
  # Note: the find_using_perishable_token helper function does not recognize
  #       tokens that are older then 10 minutes, so if a user waits longer than
  #       10 minutes to click the link then it won't work.    
  def load_taster_using_perishable_token  
    @taster = Taster.find_using_perishable_token(params[:id])  
    unless @taster
      render :action => 'not_found', :layout => 'single_column'
    end  
  end  
  
end






