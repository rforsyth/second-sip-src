require 'spec_helper'

describe Taster do
  fixtures :tasters
  
  it "can be instantiated" do
    Taster.new.should be_an_instance_of(Taster)
  end


end