require 'test_helper'

class TradeSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trade_sheet = trade_sheets(:one)
  end

  test "should get index" do
    get trade_sheets_url
    assert_response :success
  end

  test "should get new" do
    get new_trade_sheet_url
    assert_response :success
  end

  test "should create trade_sheet" do
    assert_difference('TradeSheet.count') do
      post trade_sheets_url, params: { trade_sheet: { league_id: @trade_sheet.league_id, week: @trade_sheet.week } }
    end

    assert_redirected_to trade_sheet_url(TradeSheet.last)
  end

  test "should show trade_sheet" do
    get trade_sheet_url(@trade_sheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_trade_sheet_url(@trade_sheet)
    assert_response :success
  end

  test "should update trade_sheet" do
    patch trade_sheet_url(@trade_sheet), params: { trade_sheet: { league_id: @trade_sheet.league_id, week: @trade_sheet.week } }
    assert_redirected_to trade_sheet_url(@trade_sheet)
  end

  test "should destroy trade_sheet" do
    assert_difference('TradeSheet.count', -1) do
      delete trade_sheet_url(@trade_sheet)
    end

    assert_redirected_to trade_sheets_url
  end
end
