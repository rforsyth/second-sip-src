require 'test_helper'

class LookupTest < ActiveSupport::TestCase
  setup :activate_authlogic

  setup do
    UserSession.create(users(:admin))
  end

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

	test "create lookup" do
		puts current_user.inspect
	end
end
