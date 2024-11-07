class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :gender
      t.boolean :is_temporary, default: false
      t.jsonb :meta, default: {}

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
