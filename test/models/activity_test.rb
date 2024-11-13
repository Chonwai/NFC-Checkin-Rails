# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id           :uuid             not null, primary key
#  name         :string
#  description  :text
#  start_date   :datetime         not null
#  end_date     :datetime         not null
#  qr_code_uuid :string           not null
#  meta         :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
