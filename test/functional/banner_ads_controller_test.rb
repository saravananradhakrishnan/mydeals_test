require 'test_helper'

class BannerAdsControllerTest < ActionController::TestCase
  setup do
    @banner_ad = banner_ads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:banner_ads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create banner_ad" do
    assert_difference('BannerAd.count') do
      post :create, :banner_ad => @banner_ad.attributes
    end

    assert_redirected_to banner_ad_path(assigns(:banner_ad))
  end

  test "should show banner_ad" do
    get :show, :id => @banner_ad.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @banner_ad.to_param
    assert_response :success
  end

  test "should update banner_ad" do
    put :update, :id => @banner_ad.to_param, :banner_ad => @banner_ad.attributes
    assert_redirected_to banner_ad_path(assigns(:banner_ad))
  end

  test "should destroy banner_ad" do
    assert_difference('BannerAd.count', -1) do
      delete :destroy, :id => @banner_ad.to_param
    end

    assert_redirected_to banner_ads_path
  end
end
