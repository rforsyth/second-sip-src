require 'spec_helper'

describe Brewery do
  fixtures :producers
  
  it "can be instantiated" do
    Brewery.new.should be_an_instance_of(Brewery)
  end


end