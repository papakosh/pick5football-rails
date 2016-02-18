# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160108184309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_weeks", force: true do |t|
    t.string   "year"
    t.string   "week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.string   "year"
    t.string   "week"
    t.integer  "match_num"
    t.string   "team1"
    t.string   "team2"
    t.string   "home_team"
    t.decimal  "spread"
    t.string   "favored_team"
    t.string   "date"
    t.string   "time"
    t.integer  "match_week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["match_week_id"], name: "index_matches_on_match_week_id", using: :btree

  create_table "picks", force: true do |t|
    t.text     "teams"
    t.boolean  "submitted"
    t.integer  "user_id"
    t.integer  "match_week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picks", ["match_week_id"], name: "index_picks_on_match_week_id", using: :btree
  add_index "picks", ["user_id"], name: "index_picks_on_user_id", using: :btree

  create_table "standings", force: true do |t|
    t.integer  "wins"
    t.string   "year"
    t.integer  "match_week_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "standings", ["match_week_id"], name: "index_standings_on_match_week_id", using: :btree
  add_index "standings", ["user_id"], name: "index_standings_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "user_id"
    t.string   "name"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
