# frozen_string_literal: true

module Api
  module Admin
    class LocationsController < ApplicationController
      include AdminAuthenticator
      before_action :set_activity, only: %i[create]
      before_action :set_location, only: %i[show update destroy]

      def index
        api_success(locations: Location.all)
      end

      def show
        api_success(location: @location)
      end

      def create
        location = @activity.locations.build(location_params)
        if location.save
          api_success({ location: }, :created)
        else
          api_error('地點創建失敗', :unprocessable_entity, location.errors.full_messages)
        end
      end

      def update
        if @location.update(location_params)
          api_success(location: @location)
        else
          api_error('地點更新失敗', :unprocessable_entity, @location.errors.full_messages)
        end
      end

      def destroy
        @location.destroy
        api_success(message: '地點已刪除')
      end

      private

      def set_activity
        @activity = Activity.find(params.require(:location).require(:activity_id))
      end

      def set_location
        @location = Location.find(params[:id])
      end

      def location_params
        params.require(:location).permit(:name, :address, :description, :activity_id)
      end
    end
  end
end
