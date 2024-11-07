class CouponService
  include HTTParty
  base_uri ENV.fetch('COUPON_SERVICE_URL', 'http://coupon-service.example.com')

  def self.issue_coupon(user_identifier:, activity_id:)
    response = post('/api/v1/coupons',
                    body: {
                      user_identifier:,
                      activity_id:
                    }.to_json,
                    headers: {
                      'Content-Type' => 'application/json',
                      'X-API-Key' => ENV.fetch('COUPON_SERVICE_API_KEY')
                    })

    if response.success?
      OpenStruct.new(
        success?: true,
        coupon_code: response['coupon_code'],
        coupon_id: response['id'],
        details: response['details']
      )
    else
      OpenStruct.new(
        success?: false,
        error: response['error'] || '優惠券服務無響應'
      )
    end
  rescue StandardError => e
    OpenStruct.new(
      success?: false,
      error: "優惠券服務錯誤: #{e.message}"
    )
  end
end
