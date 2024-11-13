# frozen_string_literal: true

module Api
  class LocationsController < ApplicationController
    before_action :set_activity
    before_action :set_location, only: [:show]

    def index
      render json: {
        success: true,
        locations: @activity.locations
      }
    end

    def show
      render json: {
        success: true,
        location: @location
      }
    end

    private

    def set_activity
      @activity = Activity.find(params[:activity_id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        success: false,
        error: '活動未找到'
      }, status: :not_found
    end

    def set_location
      @location = @activity.locations.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {
        success: false,
        error: '地點未找到'
      }, status: :not_found
    end
  end
end
