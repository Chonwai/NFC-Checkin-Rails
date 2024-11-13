# frozen_string_literal: true

module Api
  class ActivitiesController < ApplicationController
    before_action :set_activity, only: %i[show update]

    def index
      activities = Activity.all
      render json: activities
    end

    def show
      render json: @activity
    end

    private

    def set_activity
      @activity = Activity.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: '活動未找到' }, status: :not_found
    end

    def activity_params
      params.require(:activity).permit(:name, :date, :qr_code_uuid, :description)
    end
  end
end
