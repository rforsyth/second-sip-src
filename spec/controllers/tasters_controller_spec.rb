require 'spec_helper'
require 'authentication_helper'
require 'authlogic/test_case'

describe TastersController do
  render_views
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :tasters
  
  before(:each) do
    activate_authlogic
    #TasterSession.create(tasters(:grumpy))
  end
  
  context "when registering a new user" do

    it "should render the registration form" do
      get :new
      response.should be_success
    end

    it "should send an email after creating a new taster" do
      post :create, :taster => {:username => 'John_Doe', :real_name => 'John Doe',
                                :email => 'jdoe@hotmail.com'}
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.body.raw_source.should include "you will be able to choose a password and activate your account"
      response.should be_success
      taster = Taster.find_by_username('John_Doe')
      taster.should_not be_nil
    end

    it "should send an email after creating a new taster" do
      post :create, :taster => {:username => 'John_Doe', :real_name => 'John Doe',
                                :email => 'somevalidemail@secondsip.com'}
      response.should be_success
      assert_select "div.intro p", :text => /a link that you can use to complete your registration/
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.body.raw_source.should include "choose a password and activate your account"
    end

    it "should display error when using existing email of an active user" do
      post :create, :taster => {:username => 'John_Doe', :real_name => 'John Doe',
                                :email => 'grumpy@secondsip.com'}
      response.should be_success
      assert_select "div.intro p", :text => /If you have forgotten your password/
    end

    it "should display error when using existing email of an inactive user" do
      taster = build_valid_taster
      taster.save
      post :create, :taster => {:username => 'John_Doe', :real_name => 'John Doe',
                                :email => taster.email}
      response.should be_success
      assert_select "div.intro p", :text => /Another activation email has been sent to that account/
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.body.raw_source.should include "choose a password and activate your account"
    end
    
  end
  
  
  
end