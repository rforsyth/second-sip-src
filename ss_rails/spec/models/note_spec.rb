
#######################################################
# List of potential test cases:
# - private or friend notes are not returned to public query
# - friend notes are returned to friends, but not private
# - can switch product of note, and producer is also changed
# - calculate price from price type and price paid
#######################################################
require 'spec_helper'
require 'authlogic/test_case'

describe Note do
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :producers, :products, :notes, :tasters
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:happy))
  end
  
  it "can be instantiated" do
    BeerNote.new.should be_an_instance_of(BeerNote)
  end
  
  it "should not save until all required fields are present" do
    note = BeerNote.new
    note.valid?.should be_false
    note.visibility = Enums::Visibility::PUBLIC
    note.valid?.should be_false
    note.set_occasion('dinner', current_taster)
    note.valid?.should be_false
    note.product = products(:budweiseramericanale)
    note.valid?.should be_false
    note.tasted_at = DateTime.now
    note.valid?.should be_true
  end
  

end