
#######################################################
# List of potential test cases:
# - new personal lookup is created when adding:
#		- product.region, product.style, note.occasion, note.vineyard, note.varietal
# - existing reference lookup is used when adding value with same canonical name
# - existing personal lookup is used
# - personal lookup is renamed when lookup with same canonical name is used
# - full name of lookup with ancestors is formatted correctly
#######################################################

require 'spec_helper'
require 'authlogic/test_case'

describe ReferenceLookup do
  include Authlogic::TestCase
  fixtures :tasters, :reference_lookups
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:admin))
  end
  
  it "can be instantiated" do
    ReferenceLookup.new.should be_an_instance_of(ReferenceLookup)
  end
  
  it "should not save until all required fields are present" do
    lookup = ReferenceLookup.new
    lookup.save.should be_false
    lookup.name = 'Chateauneuf de Pope'
    lookup.save.should be_false
    lookup.lookup_type = Enums::LookupType::REGION
    lookup.save.should be_false
    lookup.entity_type = "Wine"
    lookup.save.should be_true
  end
  
  it "should allow duplicate name if different lookup type" do
    first = ReferenceLookup.create({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second = ReferenceLookup.new({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::VARIETAL})
    second.save.should be_true
  end
  
  it "should allow duplicate name if different entity type" do
    first = ReferenceLookup.create({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second = ReferenceLookup.new({:name => 'gobbledygook', :entity_type => "Beer",
                          :lookup_type => Enums::LookupType::REGION})
    second.save.should be_true
  end
  
  it "should not allow duplicate name" do
    first = ReferenceLookup.create({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second = ReferenceLookup.new({:name => 'gobbledygook', :entity_type => "Wine",
                          :lookup_type => Enums::LookupType::REGION})
    second.save.should be_false
  end
  
  it "generates the correct canonical_names" do
    lookup = ReferenceLookup.new(:name => "Shangri-la Dreaming",
                                 :lookup_type => Enums::LookupType::STYLE,
                                 :entity_type => "Beer")
    lookup.save
    lookup.canonical_name.should eql('shangriladreaming')
    lookup.canonical_full_name.should eql('shangriladreaming')
  end
  
  it "supports a hierarchy" do
    france = ReferenceLookup.new(:name => "France", :lookup_type => Enums::LookupType::REGION,
                                 :entity_type => "Wine")
    france.save
    burgundy = ReferenceLookup.new(:name => "Burgundy", :lookup_type => Enums::LookupType::REGION,
                                 :entity_type => "Wine")
    burgundy.parent_reference_lookup = france
    burgundy.save
    bordeaux = ReferenceLookup.new(:name => "Bordeaux", :lookup_type => Enums::LookupType::REGION,
                                 :entity_type => "Wine")
    bordeaux.parent_reference_lookup = france
    bordeaux.save
    burgundy.parent_reference_lookup.name.should eql('France')
  
    child_names = france.child_reference_lookups.collect {|child| child.name}
    
    assert(child_names.include?('Burgundy'))
    assert(child_names.include?('Bordeaux'))
    
    burgundy.full_name.should eql('France > Burgundy')
    burgundy.canonical_full_name.should eql('franceburgundy')
  end

end

