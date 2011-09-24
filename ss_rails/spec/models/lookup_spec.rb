require 'spec_helper'
require 'authlogic/test_case'

describe Lookup do
  include Authlogic::TestCase
  fixtures :tasters, :lookups
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:grumpy))
  end
  
  it "can be instantiated" do
    Lookup.new.should be_an_instance_of(Lookup)
  end
  
  it "should not save until all required fields are present" do
    lookup = Lookup.new
    lookup.save.should be_false
    lookup.name = 'Chateauneuf de Pope'
    lookup.save.should be_false
    lookup.lookup_type = Enums::LookupType::REGION
    lookup.save.should be_false
    lookup.entity_type = "Wine"
    lookup.save.should be_true
  end
  
  it "should allow duplicate name if different lookup type" do
    first = Lookup.create({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second = Lookup.new({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::VARIETAL})
    second.save.should be_true
  end
  
  it "should allow duplicate name if different entity type" do
    first = Lookup.create({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second = Lookup.new({:name => 'gobbledygook', :entity_type => "Beer",
                          :lookup_type => Enums::LookupType::REGION})
    second.save.should be_true
  end
  
  it "should not allow duplicate name" do
    first = Lookup.create({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second = Lookup.new({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second.save.should be_false
  end


end


