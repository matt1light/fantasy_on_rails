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

  test "one for one trade should be beneficial" do
    team1 = Team.new(number: 1, league: @league)
    team2 = Team.new(number: 2, league: @league)
    qb1 = Player.create!(team: team1, name: 'QB1', position: 'QB', value: 20)
    qb2 = Player.create!(team: team1, name: 'QB2', position: 'QB', value: 10)
    te1 = Player.create!(team: team2, name: 'TE1', position: 'TE', value: 20)
    te2 = Player.create!(team: team2, name: 'TE2', position: 'TE', value: 10)
    assert_difference 'Trade.count', 4 do
      @league.one_for_one_trades(team1, team2)
    end
    assert Trade.first.player.include?(qb1) && Trade.first.player.include?(te1),
           Trade.first.player
    assert Trade.second.player.include?(qb1) && Trade.second.player.include?(te2),
           Trade.second.player
    assert Trade.third.player.include?(qb2) && Trade.third.player.include?(te1),
           Trade.third.player
    assert Trade.fourth.player.include?(qb2) && Trade.fourth.player.include?(te2),
           Trade.fourth.player
  end
end
