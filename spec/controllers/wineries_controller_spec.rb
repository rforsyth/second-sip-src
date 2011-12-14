require 'spec_helper'
require 'authentication_helper'
require 'authlogic/test_case'

describe WineriesController do
  render_views
  include Authlogic::TestCase
  include AuthenticationHelper
  fixtures :producers
  fixtures :tasters
  
  before(:each) do
    activate_authlogic
    TasterSession.create(tasters(:grumpy))
  end
  
  context "when creating a winery" do

    it "should be able to create a minimal winery" do
      post :create, :taster_id => current_taster.username,
                    :winery => {:name => 'Gallo', :visibility => Enums::Visibility::PUBLIC}
      response.should be_redirect
      winery = Winery.find_by_name('Gallo')
      winery.should_not be_nil
    end
    
  end
  
  
  
end