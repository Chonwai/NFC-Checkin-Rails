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
#  device_id    :string           default(""), not null
#
require 'test_helper'

class TempUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
