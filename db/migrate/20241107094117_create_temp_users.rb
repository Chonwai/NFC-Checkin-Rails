class CreateTempUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :temp_users, id: :uuid do |t|
      t.string :phone
      t.string :email
      t.references :activity, null: true, foreign_key: true, type: :uuid
      t.references :user, null: true, foreign_key: true, type: :uuid
      t.boolean :is_temporary, default: true
      t.jsonb :meta, default: {}

      t.timestamps
    end
  end
end
