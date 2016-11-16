class LinkPlayersAndTrades < ActiveRecord::Migration
  def change
    create_table :players_trades, id: false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :trade, index: true
    end
  end
end
