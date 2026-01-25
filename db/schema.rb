# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_25_102518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "tracklists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "artwork", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
  end

  create_table "tracklists_tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "track_id"
    t.integer "track_number", null: false
    t.uuid "tracklist_id"
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_tracklists_tracks_on_track_id"
    t.index ["tracklist_id"], name: "index_tracklists_tracks_on_tracklist_id"
  end

  create_table "tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "artist", null: false
    t.float "bpm", null: false
    t.datetime "created_at", null: false
    t.string "genre", null: false
    t.string "key", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tracklists_tracks", "tracklists"
  add_foreign_key "tracklists_tracks", "tracks"
end
