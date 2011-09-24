require 'spec_helper'
require 'authlogic/test_case'

describe ReferenceProduct do
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :reference_producers, :reference_products, :tasters
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:admin))
  end
  
  it "can be instantiated" do
    ReferenceBeer.new.should be_an_instance_of(ReferenceBeer)
  end
  
  it "should not save until all required fields are present" do
    beer = ReferenceBeer.new
    beer.save.should be_false
    beer.set_lookup_properties({:reference_producer_name => 'Budweiser'}, ReferenceBrewery)
    beer.save.should be_false
    beer.name = 'Stella'
    beer.save.should be_true
  end

  it "should not allow products with the same name" do
    first_beer = ReferenceBeer.new(:name => 'Stella')
    first_beer.set_lookup_properties({:reference_producer_name => 'Budweiser'}, ReferenceBrewery)
    first_beer.save.should be_true
    
    second_beer = ReferenceBeer.new(:name => 'St ell a')
    first_beer.set_lookup_properties({:reference_producer_name => 'Budweiser'}, ReferenceBrewery)
    second_beer.save.should be_false
  end
  
  it "creates a new parent producer when name doesnt match existing producer" do
    brewery = ReferenceBrewery.find_by_canonical_name('rochefort')
    brewery.should be_nil
    beer = ReferenceBeer.new(:name => 'Tripel')
    beer.set_lookup_properties({:reference_producer_name => 'Rochefort'}, ReferenceBrewery)
    beer.save
    brewery = ReferenceBrewery.find_by_canonical_name('rochefort')
    brewery.name.should eql('Rochefort')
  end
  
  it "uses an existing producer when name matches" do
    ReferenceBrewery.where(:canonical_name => 'chimay').count.should eql(1)
    beer = ReferenceBeer.new(:name => 'Maroon')
    beer.set_lookup_properties({:reference_producer_name => 'Chimay'}, ReferenceBrewery)
    beer.save
    ReferenceBrewery.where(:canonical_name => 'chimay').count.should eql(1)
    beer.reference_producer.name.should eql('Chimay')
  end


end