# frozen_string_literal: true

module Api
  module Admin
    class ActivitiesController < ApplicationController
      include AdminAuthenticator
      before_action :set_activity, only: %i[show update destroy]

      def index
        activities = Activity.all
        render json: {
          success: true,
          activities: activities.as_json(include: :locations)
        }
      end

      def show
        render json: {
          success: true,
          activity: @activity.as_json(include: :locations)
        }
      end

      def create
        activity = Activity.new(activity_params)
        if activity.save
          render json: {
            success: true,
            activity:
          }, status: :created
        else
          render json: {
            success: false,
            errors: activity.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @activity.update(activity_params)
          render json: {
            success: true,
            activity: @activity
          }
        else
          render json: {
            success: false,
            errors: @activity.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @activity.destroy
        render json: {
          success: true,
          message: '活動已刪除'
        }
      end

      private

      def set_activity
        @activity = Activity.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          error: '活動未找到'
        }, status: :not_found
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
