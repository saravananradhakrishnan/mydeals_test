require 'test_helper'

class QuantitativeDiscountsControllerTest < ActionController::TestCase
  setup do
    @quantitative_discount = quantitative_discounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quantitative_discounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quantitative_discount" do
    assert_difference('QuantitativeDiscount.count') do
      post :create, :quantitative_discount => @quantitative_discount.attributes
    end

    assert_redirected_to quantitative_discount_path(assigns(:quantitative_discount))
  end

  test "should show quantitative_discount" do
    get :show, :id => @quantitative_discount.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @quantitative_discount.to_param
    assert_response :success
  end

  test "should update quantitative_discount" do
    put :update, :id => @quantitative_discount.to_param, :quantitative_discount => @quantitative_discount.attributes
    assert_redirected_to quantitative_discount_path(assigns(:quantitative_discount))
  end

  test "should destroy quantitative_discount" do
    assert_difference('QuantitativeDiscount.count', -1) do
      delete :destroy, :id => @quantitative_discount.to_param
    end

    assert_redirected_to quantitative_discounts_path
  end
end
