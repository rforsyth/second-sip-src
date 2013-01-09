
require 'api/api_configuration'

class ApiStartupController < ApiController
  
  def configuration
    configuration = Api::ApiConfiguration.new('http', 0)
    #configuration.message_title = 'Got Yer Message'
    #configuration.message_detail = 'Hello Startup!'
    configuration.allow_access = 1
    render :json => configuration
  end
  
  def register
    if(new_taster = Taster.find_by_email(params[:taster][:email]))
      if new_taster.active?
        response = Api::ErrorResults.new(:register, 'Unable to Register', 
          'There is already an active account with that email address')
        return render :json => response, :status => 500
      else
        new_taster.deliver_activation_instructions!
        response = Api::ErrorResults.new(:register, 'Unable to Register', 
          'You are registered, but have not activated the account.  Another activation email has been sent to the address on file.')
        return render :json => response, :status => 500
      end
    else
      new_taster = Taster.new
    end

    if new_taster.signup!(params)
      new_taster.deliver_activation_instructions!
      api_taster = new_taster.api_copy
      render :json => api_taster
    else
      response = build_validation_error_response(:register, 'Unable to Register', 
        'Please use these guidelines' , new_taster)
      return render :json => response, :status => 500
    end
  end
  
  def forgot_password
    taster = Taster.find_by_email(params[:email])  
    if taster  
      if taster.active?
        taster.deliver_password_reset_instructions!
        render :json => api_taster
      else
        response = Api::ErrorResults.new(:register, 'Unable to Reset Password', 
          'Your account has not been activated yet.  Check your email inbox for activation instructions.')
        return render :json => response, :status => 500
      end
    else  
      response = Api::ErrorResults.new(:register, 'Unable to Reset Password', 
        'We do not have a record of any member with the email address #{params[:email]}.')
      return render :json => response, :status => 500 
    end  
  end
  
end