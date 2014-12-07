require 'test_helper'

class BuysellCategoriesControllerTest < ActionController::TestCase
  setup do
    @buysell_category = buysell_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buysell_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buysell_category" do
    assert_difference('BuysellCategory.count') do
      post :create, :buysell_category => @buysell_category.attributes
    end

    assert_redirected_to buysell_category_path(assigns(:buysell_category))
  end

  test "should show buysell_category" do
    get :show, :id => @buysell_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @buysell_category.to_param
    assert_response :success
  end

  test "should update buysell_category" do
    put :update, :id => @buysell_category.to_param, :buysell_category => @buysell_category.attributes
    assert_redirected_to buysell_category_path(assigns(:buysell_category))
  end

  test "should destroy buysell_category" do
    assert_difference('BuysellCategory.count', -1) do
      delete :destroy, :id => @buysell_category.to_param
    end

    assert_redirected_to buysell_categories_path
  end
end
