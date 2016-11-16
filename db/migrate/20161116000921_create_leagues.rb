class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :number
      t.string :site

      t.timestamps null: false
    end
  end
end
