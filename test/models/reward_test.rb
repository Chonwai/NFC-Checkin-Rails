# frozen_string_literal: true

# == Schema Information
#
# Table name: rewards
#
#  id             :uuid             not null, primary key
#  temp_user_id   :uuid             not null
#  reward_type    :string           not null
#  reward_content :string           not null
#  issued_at      :datetime         not null
#  redeemed       :boolean          default(FALSE), not null
#  meta           :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
