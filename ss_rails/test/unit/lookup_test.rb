require 'test_helper'

#######################################################
# List of potential test cases:
# - new personal lookup is created when adding:
#		- product.region, product.style, note.occasion, note.vineyard, note.varietal
# - existing reference lookup is used when adding value with same canonical name
# - existing personal lookup is used
# - personal lookup is renamed when lookup with same canonical name is used
# - full name of lookup with ancestors is formatted correctly
#######################################################

class LookupTest < ActiveSupport::TestCase
  setup :activate_authlogic

  setup do
    UserSession.create(users(:admin))
  end

	test "generated names are correct" do
		lookup = Lookup.new(:name => "Shangri-la Dreaming",
											  :lookup_type => Enums::LookupType::STYLE,
											  :entity_type => "Beer")
		lookup.save
		assert_equal('shangriladreaming', lookup.canonical_name)
		assert_equal('shangriladreaming', lookup.canonical_full_name)
	end
	
	test "build lookup hierarchy" do
		france = Lookup.new(:name => "France", :lookup_type => Enums::LookupType::REGION, :entity_type => "Wine")
		france.save
		burgundy = Lookup.new(:name => "Burgundy", :lookup_type => Enums::LookupType::REGION, :entity_type => "Wine")
		burgundy.parent_lookup = france
		burgundy.save
		bordeaux = Lookup.new(:name => "Bordeaux", :lookup_type => Enums::LookupType::REGION, :entity_type => "Wine")
		bordeaux.parent_lookup = france
		bordeaux.save
		assert_equal('France', burgundy.parent_lookup.name)
		assert_equal('France', bordeaux.parent_lookup.name)

		child_names = france.child_lookups.collect {|child| child.name}
		assert(child_names.include?('Burgundy'))
		assert(child_names.include?('Bordeaux'))
		
		assert_equal('France > Burgundy', burgundy.full_name)
		assert_equal('franceburgundy', burgundy.canonical_full_name)
	end

	test "create lookup" do
		#puts current_user.inspect
	end
end
