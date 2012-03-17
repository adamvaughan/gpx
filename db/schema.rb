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

ActiveRecord::Schema.define(:version => 20120317194434) do

  create_table "points", :force => true do |t|
    t.datetime "time"
    t.decimal  "latitude",        :precision => 20, :scale => 10
    t.decimal  "longitude",       :precision => 20, :scale => 10
    t.decimal  "elevation",       :precision => 20, :scale => 10
    t.decimal  "distance",        :precision => 20, :scale => 10
    t.decimal  "duration",        :precision => 20, :scale => 10
    t.decimal  "active_duration", :precision => 20, :scale => 10
    t.decimal  "pace",            :precision => 20, :scale => 10
    t.decimal  "speed",           :precision => 20, :scale => 10
    t.integer  "segment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "heart_rate"
  end

  create_table "records", :force => true do |t|
    t.integer  "best_distance_segment_id"
    t.decimal  "best_year_distance"
    t.decimal  "best_month_distance"
    t.decimal  "best_week_distance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "best_year_duration"
    t.decimal  "best_month_duration"
    t.decimal  "best_week_duration"
    t.integer  "best_duration_segment_id"
  end

  create_table "reports", :force => true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "week"
    t.integer  "year_segment_count"
    t.decimal  "year_distance",        :precision => 20, :scale => 10
    t.decimal  "year_duration",        :precision => 20, :scale => 10
    t.decimal  "month_distance",       :precision => 20, :scale => 10
    t.decimal  "month_duration",       :precision => 20, :scale => 10
    t.decimal  "week_distance",        :precision => 20, :scale => 10
    t.decimal  "week_duration",        :precision => 20, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week_segment_count"
    t.integer  "month_segment_count"
    t.decimal  "year_elevation_gain",  :precision => 20, :scale => 10
    t.decimal  "month_elevation_gain", :precision => 20, :scale => 10
    t.decimal  "week_elevation_gain",  :precision => 20, :scale => 10
  end

  create_table "segments", :force => true do |t|
    t.datetime "start_time"
    t.decimal  "distance"
    t.decimal  "ascending_distance"
    t.decimal  "descending_distance"
    t.decimal  "flat_distance"
    t.decimal  "elevation_gain"
    t.decimal  "elevation_loss"
    t.decimal  "elevation_change"
    t.decimal  "maximum_elevation"
    t.decimal  "minimum_elevation"
    t.decimal  "duration"
    t.decimal  "active_duration"
    t.decimal  "ascending_duration"
    t.decimal  "descending_duration"
    t.decimal  "flat_duration"
    t.decimal  "average_pace"
    t.decimal  "average_ascending_pace"
    t.decimal  "average_descending_pace"
    t.decimal  "average_flat_pace"
    t.decimal  "average_speed"
    t.decimal  "average_ascending_speed"
    t.decimal  "average_descending_speed"
    t.decimal  "average_flat_speed"
    t.decimal  "maximum_speed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maximum_heart_rate"
    t.decimal  "average_heart_rate"
  end

end
