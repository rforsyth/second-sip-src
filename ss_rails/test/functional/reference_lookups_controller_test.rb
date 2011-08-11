require 'test_helper'

class ReferenceLookupsControllerTest < ActionController::TestCase
  setup do
    @reference_lookup = reference_lookups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reference_lookups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reference_lookup" do
    assert_difference('ReferenceLookup.count') do
      post :create, :reference_lookup => @reference_lookup.attributes
    end

    assert_redirected_to reference_lookup_path(assigns(:reference_lookup))
  end

  test "should show reference_lookup" do
    get :show, :id => @reference_lookup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reference_lookup.to_param
    assert_response :success
  end

  test "should update reference_lookup" do
    put :update, :id => @reference_lookup.to_param, :reference_lookup => @reference_lookup.attributes
    assert_redirected_to reference_lookup_path(assigns(:reference_lookup))
  end

  test "should destroy reference_lookup" do
    assert_difference('ReferenceLookup.count', -1) do
      delete :destroy, :id => @reference_lookup.to_param
    end

    assert_redirected_to reference_lookups_path
  end
end
