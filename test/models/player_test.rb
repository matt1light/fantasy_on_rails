require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = Player.new(name: 'Rob Gronkowski', value: 25)
  end

  test "Should open reddit" do
    @player.open_reddit
    # not really a test, just make sure that reddit opens properly
  end
end
