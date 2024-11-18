# frozen_string_literal: true

# == Schema Information
#
# Table name: check_in_tokens
#
#  id          :uuid             not null, primary key
#  activity_id :uuid             not null
#  location_id :uuid             not null
#  token       :string           not null
#  expires_at  :datetime         not null
#  used_at     :datetime
#  is_used     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class CheckInToken < ApplicationRecord
  belongs_to :activity
  belongs_to :location

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :valid_tokens, -> { where(is_used: false).where('expires_at > ?', Time.current) }

  def mark_as_used!
    update!(is_used: true, used_at: Time.current)
  end

  def is_valid_token?
    !is_used && expires_at > Time.current
  end
end
