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

ActiveRecord::Schema.define(version: 20170517111153) do

  create_table "beds", force: :cascade do |t|
    t.string "bed_code"
    t.string "room_class_code"
    t.string "room_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_code"], name: "index_beds_on_bed_code", unique: true
    t.index ["room_class_code"], name: "index_beds_on_room_class_code"
    t.index ["room_code"], name: "index_beds_on_room_code"
  end

  create_table "movements", force: :cascade do |t|
    t.string "registration_code"
    t.string "bed_code"
    t.date "entry_date"
    t.date "leave_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bed_code"], name: "index_movements_on_bed_code"
    t.index ["registration_code"], name: "index_movements_on_registration_code"
  end

  create_table "registrations", force: :cascade do |t|
    t.string "registration_code"
    t.string "patient_id"
    t.string "patient_name"
    t.string "doctor_name"
    t.string "gender"
    t.date "registration_date"
    t.date "leave_date"
    t.string "diagnose", default: ""
    t.boolean "leave_status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_registrations_on_patient_id"
    t.index ["registration_code"], name: "index_registrations_on_registration_code", unique: true
  end

  create_table "room_classes", force: :cascade do |t|
    t.string "room_class_code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_class_code"], name: "index_room_classes_on_room_class_code", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_code"], name: "index_rooms_on_room_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_users_on_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
