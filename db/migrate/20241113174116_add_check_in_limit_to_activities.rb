# frozen_string_literal: true

class AddCheckInLimitToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :check_in_limit, :integer, default: 1
    add_column :activities, :single_location_only, :boolean, default: false
  end
end
