require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = Player.new(name: 'Rob Gronkowski', value: 25, position: 'TE')
  end

  test "Should open reddit" do
    @player.open_reddit
    # not really a test, just make sure that reddit opens properly
  end

  test "Free agent replacement should return free agents that are better" do
    free_agent_team = Team.create!(name: 'team', number: 0)
    free_agent = Player.create!(name: 'Jon', value: 26, team: free_agent_team, position: 'TE')
    assert_includes @player.find_replacement,
                    free_agent
  end
end
