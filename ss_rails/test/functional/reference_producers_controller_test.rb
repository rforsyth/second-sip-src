require 'test_helper'

class ReferenceProducersControllerTest < ActionController::TestCase
  setup do
    @reference_producer = reference_producers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reference_producers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reference_producer" do
    assert_difference('ReferenceProducer.count') do
      post :create, :reference_producer => @reference_producer.attributes
    end

    assert_redirected_to reference_producer_path(assigns(:reference_producer))
  end

  test "should show reference_producer" do
    get :show, :id => @reference_producer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reference_producer.to_param
    assert_response :success
  end

  test "should update reference_producer" do
    put :update, :id => @reference_producer.to_param, :reference_producer => @reference_producer.attributes
    assert_redirected_to reference_producer_path(assigns(:reference_producer))
  end

  test "should destroy reference_producer" do
    assert_difference('ReferenceProducer.count', -1) do
      delete :destroy, :id => @reference_producer.to_param
    end

    assert_redirected_to reference_producers_path
  end
end
