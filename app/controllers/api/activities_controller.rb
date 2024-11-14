# frozen_string_literal: true

module Api
  class ActivitiesController < ApplicationController
    before_action :set_activity, only: %i[show update]

    def index
      activities = Activity.active
      render json: {
        success: true,
        activities:
      }
    end

    def show
      render json: {
        success: true,
        activity: @activity.as_json(include: :locations)
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
