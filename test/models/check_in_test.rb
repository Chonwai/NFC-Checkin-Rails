# == Schema Information
#
# Table name: check_ins
#
#  id           :uuid             not null, primary key
#  temp_user_id :uuid             not null
#  location_id  :uuid             not null
#  checkin_time :datetime         not null
#  meta         :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class CheckInTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
