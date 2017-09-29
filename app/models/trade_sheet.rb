class TradeSheet < ApplicationRecord
  belongs_to :league
  has_many :trade, inverse_of: :trade_sheet
  has_and_belongs_to_many :team, inverse_of: :trade_sheet

  def one_for_one_trades
    team1 = self.team.first
    team2 = self.team.second
    old_total = team1.get_starters_total + team2.get_starters_total
    team1.player.each do |player1|
      team2.player.each do |player2|
        trade = swap_and_recalc(team1, team2, [player1], [player2])
        if trade[:total_value] > old_total
          Trade.create(trade_sheet: self,
                       my_value: trade[:value1], 
                       other_value: trade[:value2], 
                       player: [player1, player2])
        end
      end
    end
  end

  def swap_and_recalc(team1, team2, players1, players2)
    players1.each do |player|
      player.update(team: team2)
    end
    players2.each do |player|
      player.update(team: team1)
    end
    team1.set_starters
    team2.set_starters
    team1Value = team1.get_starters_total
    team2Value = team2.get_starters_total
    players1.each do |player|
      player.update(team: team1)
    end
    players2.each do |player|
      player.update(team: team2)
    end
    {value1: team1Value, value2: team2Value, total_value: team1Value + team2Value}
  end
end
