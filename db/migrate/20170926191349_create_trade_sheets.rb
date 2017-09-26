class CreateTradeSheets < ActiveRecord::Migration[5.0]
  def change
    create_table :trade_sheets do |t|
      t.integer :week
      t.belongs_to :league, foreign_key: true

      t.timestamps
    end
  end
end
