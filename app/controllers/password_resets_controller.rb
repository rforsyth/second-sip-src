class PasswordResetsController < ApplicationController
  before_filter :load_taster_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_taster
	before_filter :initialize_register_or_login_tabs
	#force_ssl :only => [:edit, :update]

  def new   
  end  
  
  def edit
  end
  
  def create  
    @taster = Taster.find_by_email(params[:email])  
    if @taster  
      if @taster.active?
        @taster.deliver_password_reset_instructions!
        render :action => 'success', :layout => 'single_column'
      else
        flash[:notice] = "Your account has not been activated yet.  Check your email inbox for activation instructions."  
        render :action => :new
      end
    else  
      flash[:notice] = "We do not have a record of any member with the email address #{params[:email]}."  
      render :action => :new  
    end  
  end  
  
  def update
    password = params[:taster][:password]
    # not sure how to get authlogic validations to work in all cases
    # including register / activate / update (some which include pwd, and others that don't)
    # so we're doing it manually here
    if !(password.present? && password.length > 4)
      @taster.errors.add(:password, ' must be at least 4 characters long')
      return render :action => :edit  
    end
    @taster.password = password
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
  #       tokens that are older then 60 minutes, so if a user waits longer than
  #       60 minutes to click the link then it won't work.    
  def load_taster_using_perishable_token  
    @taster = Taster.find_using_perishable_token(params[:id])  
    unless @taster
      render :action => 'not_found', :layout => 'single_column'
    end  
  end  
  
end






