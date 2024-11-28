# frozen_string_literal: true

module Api
  module Admin
    class CheckInsController < ApplicationController
      include AdminAuthenticator

      def time_distribution
        # 按小時統計打卡數量
        hourly_stats = CheckIn.group("DATE_PART('hour', checkin_time)")
                              .count
                              .transform_keys(&:to_i)
                              .sort.to_h

        # 按星期統計打卡數量
        weekly_stats = CheckIn.group('EXTRACT(DOW FROM checkin_time)')
                              .count
                              .transform_keys(&:to_i)
                              .sort.to_h

        api_success(
          hourly_distribution: hourly_stats,
          weekly_distribution: weekly_stats
        )
      end

      def location_heat_map
        heat_map = Location.joins(:check_ins)
                           .group('locations.id', 'locations.name')
                           .select(
                             'locations.name',
                             'COUNT(check_ins.id) as check_in_count',
                             'COUNT(DISTINCT check_ins.temp_user_id) as unique_users',
                             'AVG(EXTRACT(HOUR FROM check_ins.checkin_time)) as avg_check_in_hour'
                           )
                           .order('check_in_count DESC')

        api_success(location_heat_map: heat_map)
      end

      def user_behavior
        stats = TempUser.joins(:check_ins)
                        .group(:id)
                        .select(
                          'temp_users.id',
                          'COUNT(check_ins.id) as total_check_ins',
                          'MIN(check_ins.checkin_time) as first_check_in',
                          'MAX(check_ins.checkin_time) as last_check_in',
                          '(MAX(check_ins.checkin_time) - MIN(check_ins.checkin_time)) as duration'
                        )

        api_success(user_behavior_stats: stats)
      end

      def completion_trend
        trend_data = Activity.includes(:temp_users, :check_ins)
                             .map do |activity|
          {
            activity_name: activity.name,
            total_users: activity.temp_users.count,
            completion_rate: calculate_completion_rate(activity)
          }
        end

        api_success(completion_trend: trend_data)
      end

      private

      def calculate_completion_rate(activity)
        return 0 if activity.temp_users.empty?

        completed_users = activity.temp_users
                                  .joins(:check_ins)
                                  .group('temp_users.id')
                                  .having('COUNT(DISTINCT check_ins.location_id) = ?', activity.locations.count)
                                  .count.length

        (completed_users.to_f / activity.temp_users.count * 100).round(2)
      end
    end
  end
end
