require 'test_helper'

#######################################################
# List of potential test cases:
# - private or friend products are not returned to public query
# - friend products are returned to friends, but not private
# - both reference and personal products are returned to drop-down
#######################################################

class ProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
