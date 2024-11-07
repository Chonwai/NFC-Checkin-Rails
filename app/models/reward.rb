class Reward < ApplicationRecord
  belongs_to :temp_user

  validates :reward_type, presence: true
  validates :issued_at, presence: true
  validates :redeemed, inclusion: { in: [true, false] }

  before_validation :set_defaults

  private

  def set_defaults
    self.issued_at = Time.current if issued_at.blank?
    self.redeemed = false if redeemed.nil?
  end
end
