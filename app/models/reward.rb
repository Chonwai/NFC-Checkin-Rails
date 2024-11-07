# == Schema Information
#
# Table name: rewards
#
#  id             :uuid             not null, primary key
#  temp_user_id   :uuid             not null
#  reward_type    :string           not null
#  reward_content :string           not null
#  issued_at      :datetime         not null
#  redeemed       :boolean          default(FALSE), not null
#  meta           :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
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
