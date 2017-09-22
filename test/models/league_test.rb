require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  setup do
    @league = League.new()
  end

  test "scrape_league should make all teams" do
    @league.update(number: 4430415, site: 'NFL')
    @league.scrape_league(10)
    assert 11,
           @league.team.length
    assert 15,
           @league.team[10].player.length
  end
end
