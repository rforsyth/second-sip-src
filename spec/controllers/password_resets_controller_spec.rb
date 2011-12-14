require 'spec_helper'
require 'authentication_helper'
require 'authlogic/test_case'

describe PasswordResetsController do
  render_views
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :tasters
  
  before(:each) do
    activate_authlogic
  end

  it "should display error for invalid email" do
    post :create, :email => 'foo@bar.com'
    response.should be_success
    assert_select '.error_explanation', :text => /We do not have a record of any member with the email/
  end

  it "should display error for inactive member" do
    taster = build_valid_taster
    taster.save
    post :create, :email => taster.email
    response.should be_success
    assert_select '.error_explanation', :text => /Your account has not been activated yet/
  end  
    
  it "should send an email to a valid email address" do
    post :create, :email => tasters(:grumpy).email
    response.should be_success
    assert_select "div.intro p", :text => /Instructions for setting a new password have/
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.body.raw_source.should include "Use the link below to choose a new Second Sip password"
  end
  
  it "should display error for invalid token" do
    get :edit, :id => 'foo'
    response.should be_success
    assert_select "div.intro p", :text => /the account was not found.  The URL may have expired/
  end

  it "should update password of valid member" do
    # build a valid taster and request password reset
    taster = build_active_taster
    taster.save
    log_out # the reset password forms cannot be accessed when a user is logged in
    post :create, :email => taster.email
    response.should be_success
    
    taster = Taster.find(taster.id) # need to re-query the taster to get the updated perishable token
    # now render the reset password form
    get :edit, :id => taster.perishable_token
    response.should be_success
    assert_select '.content_header h1', :text => /Set Password/
    
    # submit the form with a new password
    get :update, :taster => {:password => 'updated_password', :password_confirmation => 'updated_password'},
                 :id => taster.perishable_token
    response.should be_redirect
  end

  
end