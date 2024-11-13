# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :text
#  activity_id :uuid             not null
#  address     :string
#  meta        :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Location < ApplicationRecord
  belongs_to :activity
  has_many :check_ins, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  def activity_details
    {
      name: activity.name,
      description: activity.description,
      start_date: activity.start_date,
      end_date: activity.end_date
    }
  end

  def belongs_to_activity?(activity_id)
    activity_id == activity.id
  end
end
