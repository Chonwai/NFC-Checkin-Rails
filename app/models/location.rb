class Location < ApplicationRecord
  belongs_to :activity
  has_many :check_ins, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
end
