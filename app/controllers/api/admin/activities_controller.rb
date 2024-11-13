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
          activities:
        }
      end

      def show
        render json: {
          success: true,
          activity: @activity
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
        params.require(:activity).permit(:name, :date, :qr_code_uuid, :description)
      end
    end
  end
end
