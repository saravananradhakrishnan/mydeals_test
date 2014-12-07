require 'test_helper'

class MerchantOffersControllerTest < ActionController::TestCase
  setup do
    @merchant_offer = merchant_offers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merchant_offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merchant_offer" do
    assert_difference('MerchantOffer.count') do
      post :create, :merchant_offer => @merchant_offer.attributes
    end

    assert_redirected_to merchant_offer_path(assigns(:merchant_offer))
  end

  test "should show merchant_offer" do
    get :show, :id => @merchant_offer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @merchant_offer.to_param
    assert_response :success
  end

  test "should update merchant_offer" do
    put :update, :id => @merchant_offer.to_param, :merchant_offer => @merchant_offer.attributes
    assert_redirected_to merchant_offer_path(assigns(:merchant_offer))
  end

  test "should destroy merchant_offer" do
    assert_difference('MerchantOffer.count', -1) do
      delete :destroy, :id => @merchant_offer.to_param
    end

    assert_redirected_to merchant_offers_path
  end
end
