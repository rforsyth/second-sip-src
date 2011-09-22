require 'spec_helper'


#######################################################
# List of potential test cases:
# - can't create user with same username
#######################################################


describe Taster do
  fixtures :tasters
  
  GOOD_USERNAME = 'Jane_Doe'
  GOOD_EMAIL = 'rforsyth@vt.edu'
  GOOD_REAL_NAME = 'Jane Doe'
  GOOD_PASSWORD = 'password'
  
  it "can be instantiated" do
    Taster.new.should be_an_instance_of(Taster)
  end
  
  it "should not save until all required fields are present" do
    taster = Taster.new
    taster.valid?.should be_false
    taster.username = GOOD_USERNAME
    taster.valid?.should be_false
    taster.email = GOOD_EMAIL
    taster.valid?.should be_false
    taster.real_name = GOOD_REAL_NAME
    taster.valid?.should be_true
  end
  
  it "should not allow invalid username" do
    taster = Taster.new
    taster.email = GOOD_EMAIL
    taster.real_name = GOOD_REAL_NAME
    taster.valid?.should be_false
    taster.username = '8ball'
    taster.valid?.should be_false, 'start with number'
    taster.username = '_foo'
    taster.valid?.should be_false, 'start with underscore'
    taster.username = 'foo!bar'
    taster.valid?.should be_false, 'has exclamation point'
    taster.username = 'foo&bar'
    taster.valid?.should be_false, 'has ampersand'
    taster.username = 'foo-bar'
    taster.valid?.should be_false, 'has dash'
    taster.username = 'foobar_'
    taster.valid?.should be_false, 'ends with underscore'
    taster.username = 'ABC'
    taster.valid?.should be_false, 'three characters'
    taster.username = 'A12345678901234567890'
    taster.valid?.should be_false, '21 characters'
    taster.username = 'Jane_Doe'
    taster.valid?.should be_true
  end

  it "should allow valid username" do
    taster = Taster.new
    taster.email = GOOD_EMAIL
    taster.real_name = GOOD_REAL_NAME
    taster.valid?.should be_false
    taster.username = 'Jane_Doe'
    taster.valid?.should be_true
    taster.username = 'First'
    taster.valid?.should be_true, 'four characters'
    taster.username = 'A1234567890123456789'
    taster.valid?.should be_true, '20 characters'
    taster.username = 'A12345'
    taster.valid?.should be_true, 'has numbers'
  end


end