# frozen_string_literal: true

module Api
  module Admin
    class LocationsController < ApplicationController
      include AdminAuthenticator
      before_action :set_activity, only: %i[create]
      before_action :set_location, only: %i[show update destroy]

      def index
        render json: {
          success: true,
          locations: Location.all
        }
      end

      def show
        render json: {
          success: true,
          location: Location.find(params[:id])
        }
      end

      def create
        location = @activity.locations.build(location_params)
        if location.save
          render json: {
            success: true,
            location:
          }, status: :created
        else
          render json: {
            success: false,
            errors: location.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @location.update(location_params)
          render json: {
            success: true,
            location: @location
          }
        else
          render json: {
            success: false,
            errors: @location.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @location.destroy
        render json: {
          success: true,
          message: '地點已刪除'
        }
      end

      private

      def set_activity
        @activity = Activity.find(params.require(:location).require(:activity_id))
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          error: '活動未找到'
        }, status: :not_found
      end

      def set_location
        @location = Location.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          error: '地點未找到'
        }, status: :not_found
      end

      def location_params
        params.require(:location).permit(:name, :address, :description, :activity_id)
      end
    end
  end
end
