
#######################################################
# List of potential test cases:
# - private or friend products are not returned to public query
# - friend products are returned to friends, but not private
# - both reference and personal products are returned to drop-down
#######################################################

#######################################################
# List of potential test cases:
# - private or friend producers are not returned to public query
# - friend producers are returned to friends, but not private
# - both reference and personal producers are returned to drop-down
#######################################################
require 'spec_helper'
require 'authlogic/test_case'

describe Product do
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :producers, :products, :notes, :tasters
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:grumpy))
  end
  
  it "can be instantiated" do
    Beer.new.should be_an_instance_of(Beer)
  end
  
  it "should not save until all required fields are present" do
    beer = Beer.new
    beer.save.should be_false
    beer.visibility = Enums::Visibility::PUBLIC
    beer.save.should be_false
    beer.set_lookup_properties({:producer_name => 'Budweiser'}, current_taster, Brewery)
    beer.save.should be_false
    beer.name = 'Stella'
    beer.save.should be_true
  end
  
  it "should allow products with the same name but different creators" do
    grumpys_beer = Beer.new(:name => 'InBev', :visibility => Enums::Visibility::PUBLIC)
    grumpys_beer.set_lookup_properties({:producer_name => 'Budweiser'}, current_taster, Brewery)
    grumpys_beer.save.should be_true
    grumpys_beer.creator.should eql(tasters(:grumpy))
    
    TasterSession.create(tasters(:happy))
    happys_beer = Beer.new(:name => 'InBev', :visibility => Enums::Visibility::PUBLIC)
    happys_beer.set_lookup_properties({:producer_name => 'Budweiser'}, current_taster, Brewery)
    happys_beer.save.should be_true
    happys_beer.creator.should eql(tasters(:happy))
  end

  it "should not allow products with the same name and same creators" do
    first_beer = Beer.new(:name => 'Stella', :visibility => Enums::Visibility::PUBLIC)
    first_beer.set_lookup_properties({:producer_name => 'Budweiser'}, current_taster, Brewery)
    first_beer.save.should be_true
    first_beer.creator.should eql(tasters(:grumpy))
    
    second_beer = Beer.new(:name => 'St ell a', :visibility => Enums::Visibility::PUBLIC)
    second_beer.set_lookup_properties({:producer_name => 'Budweiser'}, current_taster, Brewery)
    second_beer.save.should be_false
  end
  
  it "updates child notes when name changes" do
    product = products(:yellowtailshiraz)
    product.name = "Syrah"
    product.save
    note = notes(:yellowtailshiraz1)
    note.product_name.should eql("Syrah")
    note.product_canonical_name.should eql("syrah")
  end
  
  it "creates a new parent producer when name doesnt match existing producer" do
    brewery = Brewery.find_by_canonical_name('rochefort', :conditions => { :owner_id => current_taster.id } )
    brewery.should be_nil
    beer = Beer.new(:name => 'Tripel', :visibility => Enums::Visibility::PUBLIC)
    beer.set_lookup_properties({:producer_name => 'Rochefort'}, current_taster, Brewery)
    beer.save
    brewery = Brewery.find_by_canonical_name('rochefort', :conditions => { :owner_id => current_taster.id } )
    brewery.name.should eql('Rochefort')
  end
  
  it "uses an existing producer when name matches" do
    Brewery.where(:canonical_name => 'budweiser', :owner_id => tasters(:happy).id).count.should eql(1)
    beer = Beer.new(:name => 'Pils', :visibility => Enums::Visibility::PUBLIC)
    beer.set_lookup_properties({:producer_name => 'Budweiser'}, tasters(:happy), Brewery)
    beer.save
    Brewery.where(:canonical_name => 'budweiser', :owner_id => tasters(:happy).id).count.should eql(1)
    beer.producer.name.should eql('Budweiser')
  end


end