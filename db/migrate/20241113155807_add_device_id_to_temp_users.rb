# frozen_string_literal: true

class AddDeviceIdToTempUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :temp_users, :device_id, :string, null: false, default: ''
    add_index :temp_users, %i[device_id activity_id], unique: true,
                                                      name: 'index_temp_users_on_device_id_and_activity_id'
  end
end
