# frozen_string_literal: true

class RewardService
  def initialize(temp_user)
    @temp_user = temp_user
  end

  def grant_reward
    # 檢查是否完成所有打卡點
    return unless all_locations_checked_in?

    # 調用優惠券微服務
    coupon_response = CouponService.issue_coupon(
      user_identifier: @temp_user.uuid,
      activity_id: @temp_user.activity_id
    )

    if coupon_response.success?
      Reward.create!(
        temp_user: @temp_user,
        reward_type: 'coupon',
        reward_content: coupon_response.coupon_code,
        issued_at: Time.current,
        redeemed: false,
        meta: {
          coupon_id: coupon_response.coupon_id,
          coupon_details: coupon_response.details
        }
      )
    else
      Rails.logger.error "優惠券發放失敗: #{coupon_response.error}"
      raise StandardError, '優惠券發放失敗'
    end
  end

  private

  def all_locations_checked_in?
    activity = @temp_user.activity
    return false unless activity

    checked_location_ids = @temp_user.check_ins.pluck(:location_id)
    activity_location_ids = activity.locations.pluck(:id)

    (activity_location_ids - checked_location_ids).empty?
  end
end
