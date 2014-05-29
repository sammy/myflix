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

ActiveRecord::Schema.define(version: 20140529105549) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "recipient_name"
    t.string   "recipient_email"
    t.text     "message"
    t.integer  "inviter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queue_items", force: true do |t|
    t.integer  "position"
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "leader_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "rating"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # create_table "sqlite_sp_functions", id: false, force: true do |t|
  #   t.text "name"
  #   t.text "text"
  # end

# Could not dump table "sqlite_stat1" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

# Could not dump table "sqlite_stat3" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  # create_table "sqlite_vs_links_names", id: false, force: true do |t|
  #   t.text "name"
  #   t.text "alias"
  # end

  # create_table "sqlite_vs_properties", id: false, force: true do |t|
  #   t.text "parentType"
  #   t.text "parentName"
  #   t.text "propertyName"
  #   t.text "propertyValue"
  # end

  create_table "users", force: true do |t|
    t.string   "full_name"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.datetime "token_expiration"
    t.boolean  "is_admin"
    t.string   "customer_token"
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "image"
    t.string   "large_cover"
    t.string   "small_cover"
    t.string   "video_url"
  end

end
