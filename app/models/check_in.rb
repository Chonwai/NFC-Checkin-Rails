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
