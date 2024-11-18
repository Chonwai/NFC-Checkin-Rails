# frozen_string_literal: true

class CreateCheckInTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :check_in_tokens, id: :uuid do |t|
      t.references :activity, type: :uuid, null: false, foreign_key: true
      t.references :location, type: :uuid, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :used_at
      t.boolean :is_used, default: false
      t.timestamps
    end

    add_index :check_in_tokens, :token, unique: true
  end
end
