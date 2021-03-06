# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def print_validation_errors(object)
  if object.valid?
    puts 'no errors'
  else
    puts object.errors.inspect
  end
end


def build_valid_taster
  taster = Taster.new
  taster.email = 'jdoe@vt.edu'
  taster.real_name = 'Jane Doe'
  taster.username = 'Jane_Doe'
  return taster
end

def build_active_taster
  taster = Taster.new
  taster.signup!(:taster => {:username => 'John_Doe',
                   :email => 'john@secondsip.com', :greeting => 'Hello!',
                   :real_name => 'John Doe'})
  taster.activate!(:taster => {:password => 'password',
                     :password_confirmation => 'password'})
  return taster
end

def log_out
  taster_session = TasterSession.find
  taster_session.destroy if taster_session
end

