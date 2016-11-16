class LinkTradesAndTeams < ActiveRecord::Migration
  def change
    create_table :teams_trades, id: false do |t|
      t.belongs_to :team, index: true
      t.belongs_to :trade, index: true
    end
  end
end
