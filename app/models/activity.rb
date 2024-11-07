class Activity < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :temp_users, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :qr_code_uuid, presence: true, uniqueness: true

  before_validation :generate_qr_code_uuid

  private

  def generate_qr_code_uuid
    self.qr_code_uuid = SecureRandom.uuid if qr_code_uuid.blank?
  end
end
