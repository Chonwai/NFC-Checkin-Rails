# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_241_113_180_116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'activities', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.datetime 'start_date', null: false
    t.datetime 'end_date', null: false
    t.jsonb 'meta', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'check_in_limit', default: 1
    t.boolean 'single_location_only', default: false
  end

  create_table 'check_ins', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'temp_user_id', null: false
    t.uuid 'location_id', null: false
    t.datetime 'checkin_time', null: false
    t.jsonb 'meta', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['location_id'], name: 'index_check_ins_on_location_id'
    t.index ['temp_user_id'], name: 'index_check_ins_on_temp_user_id'
  end

  create_table 'locations', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name', null: false
    t.text 'description'
    t.uuid 'activity_id', null: false
    t.string 'address'
    t.jsonb 'meta', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['activity_id'], name: 'index_locations_on_activity_id'
  end

  create_table 'rewards', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'temp_user_id', null: false
    t.string 'reward_type', null: false
    t.string 'reward_content', null: false
    t.datetime 'issued_at', null: false
    t.boolean 'redeemed', default: false, null: false
    t.jsonb 'meta', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['temp_user_id'], name: 'index_rewards_on_temp_user_id'
  end

  create_table 'temp_users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'phone'
    t.string 'email'
    t.uuid 'activity_id'
    t.uuid 'user_id'
    t.boolean 'is_temporary', default: true
    t.jsonb 'meta', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'device_id', default: '', null: false
    t.index ['activity_id'], name: 'index_temp_users_on_activity_id'
    t.index %w[device_id activity_id], name: 'index_temp_users_on_device_id_and_activity_id', unique: true
    t.index ['user_id'], name: 'index_temp_users_on_user_id'
  end

  create_table 'users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'email'
    t.string 'phone'
    t.string 'first_name'
    t.string 'last_name'
    t.string 'username'
    t.string 'gender'
    t.boolean 'is_temporary', default: false
    t.jsonb 'meta', default: {}
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['phone'], name: 'index_users_on_phone', unique: true
  end

  add_foreign_key 'check_ins', 'locations'
  add_foreign_key 'check_ins', 'temp_users'
  add_foreign_key 'locations', 'activities'
  add_foreign_key 'rewards', 'temp_users'
  add_foreign_key 'temp_users', 'activities'
  add_foreign_key 'temp_users', 'users'
end
