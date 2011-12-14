require 'spec_helper'
require 'authlogic/test_case'

describe ReferenceProducer do
  include Authlogic::TestCase
  fixtures :reference_producers, :tasters, :reference_products
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:admin))
  end
  
  it "can be instantiated" do
    ReferenceBrewery.new.should be_an_instance_of(ReferenceBrewery)
  end
  
  it "should not save until all required fields are present" do
    brewery = ReferenceBrewery.new
    brewery.save.should be_false
    brewery.name = 'InBev'
    brewery.save.should be_true
  end

  it "should not allow producers with the same name" do
    first_brewery = ReferenceBrewery.new(:name => 'InBev')
    first_brewery.save.should be_true
    
    second_brewery = ReferenceBrewery.new(:name => 'iN b EV')
    second_brewery.save.should be_false
  end
  
  it "updates child products when name changes" do
    producer = reference_producers(:chateaustemichelle)
    producer.name = "The Chateau"
    producer.save
    product = reference_products(:chateaustemichelleriesling)
    product.reference_producer_name.should eql("The Chateau")
    product.reference_producer_canonical_name.should eql("thechateau")
  end


end