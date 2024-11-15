# frozen_string_literal: true

module Api
  class LocationsController < ApplicationController
    before_action :set_activity
    before_action :set_location, only: [:show]

    def index
      api_success(locations: @activity.locations)
    end

    def show
      api_success(location: @location)
    end

    private

    def set_activity
      @activity = Activity.find(params[:activity_id])
    end

    def set_location
      @location = @activity.locations.find(params[:id])
    end
  end
end
