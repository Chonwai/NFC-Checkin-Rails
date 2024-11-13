# frozen_string_literal: true

class RemoveQrCodeUuidFromActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :qr_code_uuid, :string
  end
end
