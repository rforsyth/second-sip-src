require 'spec_helper'
require 'authlogic/test_case'

describe AdminTag do
  include Authlogic::TestCase
  fixtures :tasters, :admin_tags
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:admin))
  end
  
  it "can be instantiated" do
    AdminTag.new.should be_an_instance_of(AdminTag)
  end
  
  it "should not save until all required fields are present" do
    tag = AdminTag.new
    tag.save.should be_false
    tag.name = 'Chateauneuf de Pope'
    tag.save.should be_false
    tag.entity_type = "Wine"
    tag.save.should be_true
  end
  
  it "should allow duplicate name if different entity type" do
    first = AdminTag.create({:name => 'gobbledygook', :entity_type => "Wine"})
    second = AdminTag.new({:name => 'gobbledygook', :entity_type => "Beer"})
    second.save.should be_true
  end
  
  it "should not allow duplicate name" do
    first = AdminTag.create({:name => 'gobbledygook', :entity_type => "Wine"})
    second = AdminTag.new({:name => 'gobbledygook', :entity_type => "Wine"})
    second.save.should be_false
  end


end