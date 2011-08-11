require 'test_helper'

class ReferenceProductsControllerTest < ActionController::TestCase
  setup do
    @reference_product = reference_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reference_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reference_product" do
    assert_difference('ReferenceProduct.count') do
      post :create, :reference_product => @reference_product.attributes
    end

    assert_redirected_to reference_product_path(assigns(:reference_product))
  end

  test "should show reference_product" do
    get :show, :id => @reference_product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reference_product.to_param
    assert_response :success
  end

  test "should update reference_product" do
    put :update, :id => @reference_product.to_param, :reference_product => @reference_product.attributes
    assert_redirected_to reference_product_path(assigns(:reference_product))
  end

  test "should destroy reference_product" do
    assert_difference('ReferenceProduct.count', -1) do
      delete :destroy, :id => @reference_product.to_param
    end

    assert_redirected_to reference_products_path
  end
end
