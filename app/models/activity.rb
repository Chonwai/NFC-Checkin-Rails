# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id           :uuid             not null, primary key
#  name         :string
#  description  :text
#  start_date   :datetime         not null
#  end_date     :datetime         not null
#  qr_code_uuid :string           not null
#  meta         :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Activity < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :temp_users, dependent: :destroy

  before_validation :generate_qr_code_uuid

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :check_in_limit, presence: true, numericality: { greater_than: 0 }
  validates :check_in_limit_consistency

  # 新增方法來獲取所有關聯的 CheckIns
  def check_ins
    CheckIn.joins(:temp_user).where(temp_users: { activity_id: id })
  end

  def location_names
    locations.pluck(:name)
  end

  def includes_location?(location_id)
    locations.exists?(id: location_id)
  end

  # 檢查是否達到打卡次數上限
  def check_in_limit_reached?(temp_user)
    temp_user.check_ins.where(location: locations).count >= check_in_limit
  end

  # 如果是單一地點模式，確保只能有一個地點
  after_save :ensure_single_location, if: :single_location_only?

  private

  def ensure_single_location
    locations.offset(1).destroy_all if locations.count > 1
  end

  def check_in_limit_consistency
    return if single_location_only

    return unless check_in_limit > 1

    errors.add(:check_in_limit, '多地點活動每個地點只能打卡一次')
  end
end
