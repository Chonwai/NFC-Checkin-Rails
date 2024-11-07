# == Schema Information
#
# Table name: locations
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :text
#  activity_id :uuid             not null
#  address     :string
#  meta        :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
