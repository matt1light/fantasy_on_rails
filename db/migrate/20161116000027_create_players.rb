class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :position
      t.boolean :starter
      t.string :name
      t.decimal :value

      t.timestamps null: false
    end
  end
end
