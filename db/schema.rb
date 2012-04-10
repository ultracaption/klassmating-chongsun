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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120410030441) do

  create_table "candidates", :force => true do |t|
    t.integer  "district_id"
    t.integer  "party_id"
    t.integer  "number"
    t.string   "name"
    t.string   "photo_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "district_votes", :force => true do |t|
    t.integer  "time"
    t.integer  "district_id"
    t.integer  "candidate_id"
    t.integer  "count"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "districts", :force => true do |t|
    t.integer  "province_id"
    t.string   "name"
    t.string   "code"
    t.integer  "total_count"
    t.integer  "voter_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "divisions", :force => true do |t|
    t.integer  "region_id"
    t.integer  "district_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "parties", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "party_candidates", :force => true do |t|
    t.integer  "party_id"
    t.integer  "number"
    t.string   "name"
    t.string   "photo_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "party_votes", :force => true do |t|
    t.integer  "time"
    t.integer  "region_id"
    t.integer  "party_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "regions", :force => true do |t|
    t.integer  "province_id"
    t.string   "name"
    t.integer  "total_count"
    t.integer  "voter_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "turnouts", :force => true do |t|
    t.integer  "time"
    t.integer  "region_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
