
#######################################################
# List of potential test cases:
# - existing tags are listed correctly
# - adding a tag that doesn't exist creates a new tag
# - using an existing tag does not create a new tag
# - can add tags to: producer, product, note
# - can add admin tags to: producer, product, note, friendship, user, lookup, resource
#######################################################
require 'spec_helper'
require 'authlogic/test_case'

describe Tag do
  include Authlogic::TestCase
  fixtures :tasters, :tags
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:grumpy))
  end
  
  it "can be instantiated" do
    Tag.new.should be_an_instance_of(Tag)
  end
  
  it "should not save until all required fields are present" do
    tag = Tag.new
    tag.save.should be_false
    tag.name = 'Chateauneuf de Pope'
    tag.save.should be_false
    tag.entity_type = "Wine"
    tag.save.should be_true
  end
  
  it "should allow duplicate name if different entity type" do
    first = Tag.create({:name => 'gobbledygook', :entity_type => "Wine"})
    second = Tag.new({:name => 'gobbledygook', :entity_type => "Beer"})
    second.save.should be_true
  end
  
  it "should not allow duplicate name" do
    first = Tag.create({:name => 'gobbledygook', :entity_type => "Wine"})
    second = Tag.new({:name => 'gobbledygook', :entity_type => "Wine"})
    second.save.should be_false
  end


end


