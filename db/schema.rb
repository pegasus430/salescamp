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

ActiveRecord::Schema.define(version: 20171026080039) do

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",       limit: 255,              null: false
    t.string   "url",        limit: 255, default: "", null: false
    t.string   "type",       limit: 255,              null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "user_id",    limit: 4
    t.string   "title",      limit: 255
    t.string   "subtitle",   limit: 255
    t.string   "color",      limit: 255
  end

  add_index "campaigns", ["user_id"], name: "index_campaigns_on_user_id", using: :btree

  create_table "milestone_awards", force: :cascade do |t|
    t.integer  "referred_user_id", limit: 4,                 null: false
    t.integer  "milestone_id",     limit: 4,                 null: false
    t.boolean  "awarded",                    default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "milestone_awards", ["milestone_id"], name: "index_milestone_awards_on_milestone_id", using: :btree
  add_index "milestone_awards", ["referred_user_id"], name: "index_milestone_awards_on_referred_user_id", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.string   "caption",        limit: 255
    t.integer  "referral_count", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "campaign_id",    limit: 4,   null: false
  end

  add_index "milestones", ["campaign_id"], name: "index_milestones_on_campaign_id", using: :btree
  add_index "milestones", ["referral_count", "campaign_id"], name: "index_milestones_on_referral_count_and_campaign_id", unique: true, using: :btree

  create_table "referred_users", force: :cascade do |t|
    t.integer  "campaign_id",      limit: 4,               null: false
    t.string   "email",            limit: 255,             null: false
    t.string   "token",            limit: 255,             null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "referred_user_id", limit: 4
    t.string   "ip_address",       limit: 255
    t.integer  "referrals",        limit: 4,   default: 0
    t.integer  "fullfilled",       limit: 4,   default: 0
  end

  add_index "referred_users", ["campaign_id", "email"], name: "index_referred_users_on_campaign_id_and_email", unique: true, using: :btree
  add_index "referred_users", ["campaign_id", "token"], name: "index_referred_users_on_campaign_id_and_token", unique: true, using: :btree
  add_index "referred_users", ["campaign_id"], name: "index_referred_users_on_campaign_id", using: :btree
  add_index "referred_users", ["referred_user_id"], name: "index_referred_users_on_referred_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "plan_id",               limit: 255, null: false
    t.string   "subscription_id",       limit: 255, null: false
    t.string   "stripe_customer_token", limit: 255, null: false
    t.integer  "user_id",               limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "active",                             default: true
    t.integer  "role",                   limit: 4,   default: 0,    null: false
    t.integer  "total_spent",            limit: 4,   default: 0
    t.integer  "payment_count",          limit: 4,   default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "campaigns", "users"
  add_foreign_key "milestones", "campaigns"
  add_foreign_key "referred_users", "campaigns"
  add_foreign_key "referred_users", "referred_users"
end
