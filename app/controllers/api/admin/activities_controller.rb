# frozen_string_literal: true

module Api
  module Admin
    class ActivitiesController < ApplicationController
      include AdminAuthenticator
      before_action :set_activity, only: %i[show update destroy]

      def index
        activities = Activity.all
        api_success(activities: activities.as_json(include: :locations))
      end

      def show
        api_success(activity: @activity.as_json(include: :locations))
      end

      def create
        activity = Activity.new(activity_params)
        if activity.save
          api_success({ activity: }, :created)
        else
          api_error('活動創建失敗', :unprocessable_entity, activity.errors.full_messages)
        end
      end

      def update
        if @activity.update(activity_params)
          api_success(activity: @activity)
        else
          api_error('活動更新失敗', :unprocessable_entity, @activity.errors.full_messages)
        end
      end

      def destroy
        @activity.destroy
        api_success(message: '活動已刪除')
      end

      private

      def set_activity
        @activity = Activity.find(params[:id])
      end

      def activity_params
        params.require(:activity).permit(
          :name,
          :start_date,
          :end_date,
          :description,
          :check_in_limit,
          :single_location_only,
          :is_active
        )
      end
    end
  end
end
