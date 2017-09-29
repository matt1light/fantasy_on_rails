class CreatesJoinTableTradeSheetTeam < ActiveRecord::Migration[5.0]
  def change
    create_join_table :trade_sheets, :teams do |t|
      t.index [:trade_sheet_id, :team_id]
      # t.index [:team_id, :trade_sheet_id]
    end
  end
end
