class TempUser < ApplicationRecord
  belongs_to :activity, optional: true
  belongs_to :user, optional: true
  has_many :check_ins, dependent: :destroy
  has_many :rewards, dependent: :destroy

  validates :is_temporary, inclusion: { in: [true, false] }
end
