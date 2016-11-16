class AddLeagueRefToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :league, index:true, foreign_key:true
  end
end
