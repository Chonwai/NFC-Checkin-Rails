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
  validate :check_in_limit_not_exceeded
  validate :location_belongs_to_activity
  validate :activity_must_be_active

  before_validation :set_checkin_time

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
    if activity.single_location_only
      # 單一地點模式：檢查總打卡次數
      errors.add(:base, '已達到打卡次數上限') if activity.check_in_limit_reached?(temp_user)
    elsif temp_user.check_ins.exists?(location_id: location.id)
      # 多地點模式：檢查每個地點是否已經打卡
      errors.add(:base, '此地點已經打卡過')
    end
  end

  def location_belongs_to_activity
    return unless temp_user && location

    return if temp_user.activity_id == location.activity_id

    errors.add(:location, '不屬於當前活動')
  end

  def activity_must_be_active
    return unless temp_user && location

    activity = location.activity
    return if activity.active?

    errors.add(:base, '此活動目前未開放打卡')
  end
end
