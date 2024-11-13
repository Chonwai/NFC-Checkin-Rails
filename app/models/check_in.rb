# frozen_string_literal: true

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

  validate :check_in_limit_not_exceeded
  validate :location_belongs_to_activity

  # 新增方法來獲取關聯的 Activity
  def activity
    temp_user.activity
  end

  private

  def set_checkin_time
    self.checkin_time = Time.current if checkin_time.blank?
  end

  def check_in_limit_not_exceeded
    return unless temp_user && location

    activity = location.activity
    return unless activity.check_in_limit_reached?(temp_user)

    errors.add(:base, '已達到打卡次數上限')
  end

  def location_belongs_to_activity
    return unless temp_user && location

    return if temp_user.activity_id == location.activity_id

    errors.add(:location, '不屬於當前活動')
  end
end
