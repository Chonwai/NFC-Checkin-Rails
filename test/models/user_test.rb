# frozen_string_literal: true

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
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
