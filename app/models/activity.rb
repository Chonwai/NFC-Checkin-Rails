# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

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
#  is_active            :boolean          default(FALSE)
#
class Activity < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :temp_users, dependent: :destroy
  has_many :check_ins, through: :temp_users

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :check_in_limit, presence: true, numericality: { greater_than: 0 }
  validates :is_active, inclusion: { in: [true, false] }

  validate :check_in_limit_consistency

  def location_names
    locations.pluck(:name)
  end

  def includes_location?(location_id)
    locations.exists?(id: location_id)
  end

  # 檢查是否達到打卡次數上限
  def check_in_limit_reached?(temp_user)
    temp_user.check_ins.where(location: locations).count >= check_in_limit
  end

  # 如果是單一地點模式，確保只能有一個地點
  after_save :ensure_single_location, if: :single_location_only?

  # 添加一個範圍方法來獲取活躍的活動
  scope :active, -> { where(is_active: true) }

  # 添加一個方法來檢查活動是否活躍
  def active?
    is_active
  end

  def has_reward_system?
    meta.dig('reward_api', 'issue_endpoint').present? &&
      meta.dig('reward_api', 'query_endpoint').present?
  end

  def reward_api_config
    return nil unless has_reward_system?

    {
      'issue_endpoint' => meta.dig('reward_api', 'issue_endpoint'),
      'query_endpoint' => meta.dig('reward_api', 'query_endpoint')
    }
  end

  def issue_reward(temp_user)
    return { success: false, error: '此活動未設置獎勵系統' } unless has_reward_system?
    return { success: false, error: '未達到打卡要求' } unless check_in_limit_reached?(temp_user)

    begin
      uri = URI(reward_api_config['issue_endpoint'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = { userId: temp_user.id }.to_json

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        { success: true, data: data['data'] }
      else
        Rails.logger.error "獎勵發放失敗: #{response.body}"
        { success: false, error: '獎勵發放失敗' }
      end
    rescue StandardError => e
      Rails.logger.error "獎勵系統錯誤: #{e.message}"
      { success: false, error: '獎勵系統發生錯誤' }
    end
  end

  def get_user_rewards(user_id)
    return { success: false, error: '此活動未設置獎勵系統' } unless has_reward_system?

    begin
      endpoint = format(reward_api_config['query_endpoint'], user_id:)
      puts "endpoint: #{endpoint}"
      uri = URI(endpoint)
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        { success: true, data: data['data'] }
      else
        Rails.logger.error "獎勵查詢失敗: #{response.body}"
        { success: false, error: '獎勵查詢失敗' }
      end
    rescue StandardError => e
      Rails.logger.error "獎勵查詢錯誤: #{e.message}"
      { success: false, error: '獎勵查詢系統發生錯誤' }
    end
  end

  private

  def ensure_single_location
    locations.offset(1).destroy_all if locations.count > 1
  end

  def check_in_limit_consistency
    return if single_location_only

    return unless check_in_limit > 1

    errors.add(:check_in_limit, '多地點活動每個地點只能打卡一次')
  end
end
