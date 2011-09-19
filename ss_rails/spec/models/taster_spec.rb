require 'spec_helper'


#######################################################
# List of potential test cases:
# - can't create user with same username
#######################################################


describe Taster do
  fixtures :tasters
  
  it "can be instantiated" do
    Taster.new.should be_an_instance_of(Taster)
  end


end