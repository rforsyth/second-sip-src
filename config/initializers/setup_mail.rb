
if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address => ‘smtp.sendgrid.net’,
    :port => ’587′,
    :authentication => :plain,
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => ‘heroku.com’
  }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default_url_options[:host] = "www.secondsip.com"
else
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "secondsip.com",
    :user_name            => "ryan.secondsip",
    :password             => "TechRefug33",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
  ActionMailer::Base.default_url_options[:host] = "localhost:3000"
  #Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?  
end

