# == Schema Information
#
# Table name: users
#
#  id           :uuid             not null, primary key
#  email        :string
#  phone        :string
#  first_name   :string
#  last_name    :string
#  username     :string
#  gender       :string
#  is_temporary :boolean          default(FALSE)
#  meta         :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class User < ApplicationRecord
  has_many :temp_users, dependent: :nullify

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, uniqueness: true
end
