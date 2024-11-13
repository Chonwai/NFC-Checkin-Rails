# frozen_string_literal: true

class CreateCheckIns < ActiveRecord::Migration[7.0]
  def change
    create_table :check_ins, id: :uuid do |t|
      t.references :temp_user, null: false, foreign_key: true, type: :uuid
      t.references :location, null: false, foreign_key: true, type: :uuid
      t.datetime :checkin_time, null: false
      t.jsonb :meta, default: {}

      t.timestamps
    end
  end
end
