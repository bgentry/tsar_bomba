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

ActiveRecord::Schema.define(version: 20141015205638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fleets", force: true do |t|
    t.string   "instance_type",                         null: false
    t.integer  "instance_count",                        null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "provider_region", default: "us-east-1", null: false
  end

  create_table "flipper_features", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "flipper_features", ["name"], name: "index_flipper_features_on_name", unique: true, using: :btree

  create_table "flipper_gates", force: true do |t|
    t.integer  "flipper_feature_id", null: false
    t.string   "name",               null: false
    t.string   "value"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "flipper_gates", ["flipper_feature_id", "name", "value"], name: "index_flipper_gates_on_flipper_feature_id_and_name_and_value", unique: true, using: :btree

  create_table "instances", force: true do |t|
    t.integer  "fleet_id"
    t.string   "provider_id"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "que_jobs", primary_key: "queue", force: true do |t|
    t.integer  "priority",    limit: 2, default: 100,                                        null: false
    t.datetime "run_at",                default: "now()",                                    null: false
    t.integer  "job_id",      limit: 8, default: "nextval('que_jobs_job_id_seq'::regclass)", null: false
    t.text     "job_class",                                                                  null: false
    t.json     "args",                  default: [],                                         null: false
    t.integer  "error_count",           default: 0,                                          null: false
    t.text     "last_error"
  end

  create_table "ssh_key_pairs", force: true do |t|
    t.text     "private_key", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "flipper_gates", "flipper_features", on_delete: :cascade
  add_foreign_key "instances", "fleets"
end
