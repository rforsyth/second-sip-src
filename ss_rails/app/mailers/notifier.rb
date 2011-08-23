class Notifier < ActionMailer::Base
  default :from => "customersupport@secondsip.com"
  
  def password_reset_instructions(taster) 
    @taster = taster
    mail(:to => taster.email, :subject => "Second Sip Password Reset")
  end 
  
  def activation_instructions(taster) 
    @taster = taster
    mail(:to => taster.email, :subject => "Second Sip Account Verification")
  end 
  
  def activation_confirmation(taster) 
    @taster = taster
    mail(:to => taster.email, :subject => "Welcome to Second Sip!")
  end 
  
end
