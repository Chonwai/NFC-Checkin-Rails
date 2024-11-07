# == Schema Information
#
# Table name: check_ins
#
#  id           :uuid             not null, primary key
#  temp_user_id :uuid             not null
#  location_id  :uuid             not null
#  checkin_time :datetime         not null
#  meta         :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CheckIn < ApplicationRecord
  belongs_to :temp_user
  belongs_to :location

  validates :checkin_time, presence: true

  before_validation :set_checkin_time

  private

  def set_checkin_time
    self.checkin_time = Time.current if checkin_time.blank?
  end
end
