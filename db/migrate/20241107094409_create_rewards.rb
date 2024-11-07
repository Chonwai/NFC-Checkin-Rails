class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards, id: :uuid do |t|
      t.references :temp_user, null: false, foreign_key: true, type: :uuid
      t.string :reward_type, null: false
      t.string :reward_content, null: false
      t.datetime :issued_at, null: false
      t.boolean :redeemed, null: false, default: false
      t.jsonb :meta, default: {}

      t.timestamps
    end
  end
end
