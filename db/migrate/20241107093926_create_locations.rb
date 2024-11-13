# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.references :activity, null: false, foreign_key: true, type: :uuid
      t.string :address
      t.jsonb :meta, default: {}

      t.timestamps
    end
  end
end
