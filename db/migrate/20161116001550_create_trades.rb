class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :my_value
      t.integer :other_value

      t.timestamps null: false
    end
  end
end
