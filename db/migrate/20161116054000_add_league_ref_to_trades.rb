class AddLeagueRefToTrades < ActiveRecord::Migration
  def change
    add_reference :trades, :league, index: true, foreign_key: true
  end
end
