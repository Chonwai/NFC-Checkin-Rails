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
end
