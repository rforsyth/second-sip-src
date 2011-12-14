require 'spec_helper'
require 'authentication_helper'
require 'authlogic/test_case'

describe ActivationsController do
  render_views
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :tasters
  
  before(:each) do
    activate_authlogic
  end
  
  context "when activating a new user" do

    it "should render the activation form" do
      taster = build_valid_taster
      taster.save
      get :new, :activation_code => taster.perishable_token
      response.should be_success
      assert_select '#taster_password'
    end

    it "should render the re-send form with invalid token" do
      get :new, :activation_code => 'bogus'
      response.should be_success
      assert_select "p", :text => /the account was not found/
    end
    
    it "should send an email after activating a taster" do
      taster = build_valid_taster
      taster.save
      post :create, :taster => {:password => 'password', :password_confirmation => 'password'},
                    :id => taster.id
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.body.raw_source.should include "You now have an online home for storing"
      response.should be_redirect
    end
    
    it "should not allow an activation email to be sent to an active user" do
      post :re_send, :email => 'grumpy@secondsip.com'
      response.should be_success
      assert_select "div.intro p", :text => /The account is already active/
    end
    
    it "should send an email with the re-send activation action" do
      taster = build_valid_taster
      taster.save
      post :re_send, :email => taster.email
      response.should be_success
      assert_select "div.intro p", :text => /An activation email has been sent/
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.body.raw_source.should include "choose a password and activate your account"
    end
    
  end
  
  
  
end