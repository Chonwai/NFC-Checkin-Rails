class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities, id: :uuid do |t|
      t.string :name
      t.text :description
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :qr_code_uuid, null: false, unique: true
      t.jsonb :meta, default: {}

      t.timestamps
    end
  end
end
