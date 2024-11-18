# frozen_string_literal: true

# == Schema Information
#
# Table name: check_in_tokens
#
#  id          :uuid             not null, primary key
#  activity_id :uuid             not null
#  location_id :uuid             not null
#  token       :string           not null
#  expires_at  :datetime         not null
#  used_at     :datetime
#  is_used     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class CheckInTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
