# frozen_string_literal: true

class CheckInToken < ApplicationRecord
  belongs_to :activity
  belongs_to :location

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :valid, -> { where(is_used: false).where('expires_at > ?', Time.current) }

  def mark_as_used!
    update!(is_used: true, used_at: Time.current)
  end

  def valid?
    !is_used && expires_at > Time.current
  end
end
