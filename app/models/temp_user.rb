# frozen_string_literal: true

# == Schema Information
#
# Table name: temp_users
#
#  id           :uuid             not null, primary key
#  phone        :string
#  email        :string
#  activity_id  :uuid
#  user_id      :uuid
#  is_temporary :boolean          default(TRUE)
#  meta         :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  device_id    :string           default(""), not null
#
class TempUser < ApplicationRecord
  belongs_to :activity
  belongs_to :user, optional: true
  has_many :check_ins, dependent: :destroy
  has_many :rewards, dependent: :destroy

  validates :is_temporary, inclusion: { in: [true, false] }
  validates :phone, presence: true, unless: :email_present_or_device_id?
  validates :email, presence: true, unless: :phone_present_or_device_id?
  validates :device_id, presence: true, if: -> { phone.blank? && email.blank? }, uniqueness: { scope: :activity_id }

  # 方法來判斷是否需要存在 phone/email 或 device_id
  def email_present_or_device_id?
    email.present? || device_id.present?
  end

  def phone_present_or_device_id?
    phone.present? || device_id.present?
  end
end
