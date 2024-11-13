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
#
class TempUser < ApplicationRecord
  belongs_to :activity
  belongs_to :user, optional: true
  has_many :check_ins, dependent: :destroy
  has_many :rewards, dependent: :destroy

  validates :is_temporary, inclusion: { in: [true, false] }
  validates :phone, presence: true, unless: :email?
  validates :email, presence: true, unless: :phone?
end
