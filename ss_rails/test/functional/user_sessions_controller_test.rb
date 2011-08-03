require 'test_helper'

class TasterSessionsControllerTest < ActionController::TestCase
  setup do
    @taster_session = taster_sessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taster_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taster_session" do
    assert_difference('TasterSession.count') do
      post :create, :taster_session => @taster_session.attributes
    end

    assert_redirected_to taster_session_path(assigns(:taster_session))
  end

  test "should show taster_session" do
    get :show, :id => @taster_session.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @taster_session.to_param
    assert_response :success
  end

  test "should update taster_session" do
    put :update, :id => @taster_session.to_param, :taster_session => @taster_session.attributes
    assert_redirected_to taster_session_path(assigns(:taster_session))
  end

  test "should destroy taster_session" do
    assert_difference('TasterSession.count', -1) do
      delete :destroy, :id => @taster_session.to_param
    end

    assert_redirected_to taster_sessions_path
  end
end
