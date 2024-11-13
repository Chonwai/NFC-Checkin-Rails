# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  description          :text
#  start_date           :datetime         not null
#  end_date             :datetime         not null
#  meta                 :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  check_in_limit       :integer          default(1)
#  single_location_only :boolean          default(FALSE)
#
require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
