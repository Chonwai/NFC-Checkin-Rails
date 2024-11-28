# frozen_string_literal: true

module Api
  module Admin
    class DashboardController < ApplicationController
      include AdminAuthenticator

      def stats
        period = params[:period] || 'all_time'

        stats = Rails.cache.fetch("admin_dashboard_stats_#{period}", expires_in: 5.minutes) do
          {
            activities: activities_stats(period),
            check_ins: check_ins_stats(period),
            users: users_stats(period),
            stats_updated_at: Time.current
          }
        end

        api_success(dashboard: stats)
      end

      def activity_engagement
        activities_data = Activity.includes(:temp_users, :check_ins)
                                  .order(created_at: :desc)
                                  .map do |activity|
          completion_stats = calculate_completion_stats(activity)
          {
            name: activity.name,
            total_users: activity.temp_users.count,
            total_check_ins: activity.check_ins.count,
            completion_stats: {
              full_completion_rate: completion_stats[:full_completion],
              partial_completion_rate: completion_stats[:partial_completion]
            },
            active_days: (activity.end_date - activity.start_date).to_i,
            status: activity.is_active ? '進行中' : '已結束'
          }
        end

        api_success(activities_data:)
      end

      def location_distribution
        locations_data = Location.left_joins(:check_ins)
                                 .group('locations.id', 'locations.name')
                                 .select(
                                   'locations.name',
                                   'COUNT(check_ins.id) as check_in_count',
                                   'COUNT(DISTINCT check_ins.temp_user_id) as unique_users'
                                 )

        api_success(locations_data:)
      end

      def user_activity_trend
        trend_data = (0..29).map do |days_ago|
          date = days_ago.days.ago.to_date
          {
            date:,
            new_users: TempUser.where('DATE(created_at) = ?', date).count,
            active_users: CheckIn.where('DATE(created_at) = ?', date)
                                 .select('DISTINCT temp_user_id').count
          }
        end

        api_success(trend_data:)
      end

      private

      def activities_stats(period)
        {
          total: scope_by_period(Activity, period).count,
          active: scope_by_period(Activity.where(is_active: true), period).count
        }
      end

      def check_ins_stats(period)
        {
          total: scope_by_period(CheckIn, period).count,
          unique_locations: scope_by_period(CheckIn.select(:location_id).distinct, period).count
        }
      end

      def users_stats(period)
        {
          total: scope_by_period(TempUser, period).count,
          active: scope_by_period(TempUser.joins(:check_ins).distinct, period).count
        }
      end

      def scope_by_period(scope, period)
        case period
        when 'today'
          scope.where('created_at >= ?', Time.current.beginning_of_day)
        when 'this_week'
          scope.where('created_at >= ?', Time.current.beginning_of_week)
        when 'this_month'
          scope.where('created_at >= ?', Time.current.beginning_of_month)
        when 'last_30_days'
          scope.where('created_at >= ?', 30.days.ago)
        else
          scope
        end
      end

      def calculate_completion_rate(activity)
        return 0 if activity.temp_users.empty?

        completed_users = activity.temp_users
                                  .joins(:check_ins)
                                  .group('temp_users.id')
                                  .having('COUNT(DISTINCT check_ins.location_id) = ?', activity.locations.count)
                                  .count.length

        (completed_users.to_f / activity.temp_users.count * 100).round(2)
      end

      def calculate_completion_stats(activity)
        return { full_completion: 0, partial_completion: 0 } if activity.temp_users.empty?

        total_locations = activity.locations.count
        user_stats = activity.temp_users
                             .joins(:check_ins)
                             .group('temp_users.id')
                             .select(
                               'temp_users.id',
                               'COUNT(DISTINCT check_ins.location_id) as completed_locations'
                             )

        {
          full_completion: (user_stats.count { |stat|
                              stat.completed_locations == total_locations
                            }.to_f / activity.temp_users.count * 100).round(2),
          partial_completion: (user_stats.count { |stat|
                                 stat.completed_locations.positive? && stat.completed_locations < total_locations
                               }.to_f / activity.temp_users.count * 100).round(2)
        }
      end
    end
  end
end
