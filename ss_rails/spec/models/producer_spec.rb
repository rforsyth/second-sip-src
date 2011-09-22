
#######################################################
# List of potential test cases:
# - private or friend producers are not returned to public query
# - friend producers are returned to friends, but not private
# - both reference and personal producers are returned to drop-down
#######################################################
require 'spec_helper'
require 'authlogic/test_case'

describe Producer do
  include Authlogic::TestCase
  fixtures :producers, :products, :notes, :tasters
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:grumpy))
  end
  
  it "can be instantiated" do
    Brewery.new.should be_an_instance_of(Brewery)
  end
  
  it "should not save until all required fields are present" do
    brewery = Brewery.new
    brewery.save.should be_false
    brewery.name = 'InBev'
    brewery.save.should be_false
    brewery.visibility = Enums::Visibility::PUBLIC
    brewery.save.should be_true
  end
  
  it "should allow producers with the same name but different creators" do
    grumpys_brewery = Brewery.new(:name => 'InBev', :visibility => Enums::Visibility::PUBLIC)
    grumpys_brewery.save.should be_true
    grumpys_brewery.creator.should eql(tasters(:grumpy))
    
    TasterSession.create(tasters(:happy))
    happys_brewery = Brewery.new(:name => 'InBev', :visibility => Enums::Visibility::PUBLIC)
    happys_brewery.save.should be_true
    happys_brewery.creator.should eql(tasters(:happy))
  end

  it "should not allow producers with the same name and same creators" do
    first_brewery = Brewery.new(:name => 'InBev', :visibility => Enums::Visibility::PUBLIC)
    first_brewery.save.should be_true
    first_brewery.creator.should eql(tasters(:grumpy))
    
    second_brewery = Brewery.new(:name => 'iN b EV', :visibility => Enums::Visibility::PUBLIC)
    second_brewery.save.should be_false
  end
  
  it "updates child products when name changes" do
    producer = producers(:yellowtail)
    producer.name = "Red Tail"
    producer.save
    product = products(:yellowtailshiraz)
    product.producer_name.should eql("Red Tail")
    product.producer_canonical_name.should eql("redtail")
    note = notes(:yellowtailshiraz1)
    note.producer_name.should eql("Red Tail")
    note.producer_canonical_name.should eql("redtail")
  end


end