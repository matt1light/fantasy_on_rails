# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170926192134) do

  create_table "leagues", force: :cascade do |t|
    t.integer  "number"
    t.string   "site"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "position"
    t.boolean  "starter"
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "players_trades", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "trade_id"
    t.index ["player_id"], name: "index_players_trades_on_player_id"
    t.index ["trade_id"], name: "index_players_trades_on_trade_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "league_id"
    t.string   "name"
    t.index ["league_id"], name: "index_teams_on_league_id"
  end

  create_table "teams_trades", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "trade_id"
    t.index ["team_id"], name: "index_teams_trades_on_team_id"
    t.index ["trade_id"], name: "index_teams_trades_on_trade_id"
  end

  create_table "trade_sheets", force: :cascade do |t|
    t.integer  "week"
    t.integer  "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_trade_sheets_on_league_id"
  end

  create_table "trades", force: :cascade do |t|
    t.integer  "my_value"
    t.integer  "other_value"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "league_id"
    t.integer  "trade_sheet_id"
    t.index ["league_id"], name: "index_trades_on_league_id"
    t.index ["trade_sheet_id"], name: "index_trades_on_trade_sheet_id"
  end

end
