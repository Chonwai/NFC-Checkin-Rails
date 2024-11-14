# frozen_string_literal: true

class AddIsActiveToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :is_active, :boolean, default: false
  end
end
