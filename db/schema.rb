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

ActiveRecord::Schema.define(version: 20150501145700) do

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensitivity_analyses", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.decimal  "net_profit_margin"
    t.decimal  "sales_commissions_rate"
    t.decimal  "sales_taxes_rate"
    t.decimal  "sales_charges_rate"
    t.decimal  "individualization_costs"
    t.decimal  "cost_per_square_meter"
    t.decimal  "land_acquisition_cost"
    t.decimal  "exchanged_units_expenses"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "unit_sensitivity_analyses", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "sensitivity_analysis_id"
    t.decimal  "sale_price"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.decimal  "private_area"
    t.decimal  "common_area"
    t.decimal  "box_area"
    t.boolean  "exchanged"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
