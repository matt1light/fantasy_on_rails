class AddSizeToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :size, :int
  end
end
