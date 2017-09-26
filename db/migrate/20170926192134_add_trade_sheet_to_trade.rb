class AddTradeSheetToTrade < ActiveRecord::Migration[5.0]
  def change
    add_reference :trades, :trade_sheet, foreign_key: true
  end
end
