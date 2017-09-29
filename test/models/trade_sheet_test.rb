require 'test_helper'

class TradeSheetTest < ActiveSupport::TestCase
  setup do
  end

  test 'test the new trade_sheet one for one trade' do
    @league = League.new()
    @league.update(number: 4430415, site: 'NFL')
    @league.scrape_league
    @ts = TradeSheet.new(league: @league)
    @ts.update(team: [@league.team[1], @league.team[2]])
    @ts.one_for_one_trades
    binding.pry
  end
end
