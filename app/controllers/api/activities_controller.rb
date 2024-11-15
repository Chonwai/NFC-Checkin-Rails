# frozen_string_literal: true

module Api
  class ActivitiesController < ApplicationController
    include ApiResponse

    before_action :set_activity, only: %i[show update]

    def index
      activities = Activity.active
      api_success(activities:)
    end

    def show
      api_success(activity: @activity.as_json(include: :locations))
    end

    def list_check_ins
      device_id = request.headers['X-Temp-User-Token']
      temp_user = TempUser.find_by(device_id:, activity_id: params[:id])

      if temp_user
        check_ins = temp_user.check_ins.includes(:location)
        api_success(check_ins: check_ins.as_json(include: :location))
      else
        api_error('臨時用戶未找到或不屬於此活動', :unprocessable_entity, code: ErrorCodes::UNAUTHORIZED)
      end
    end

    private

    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:name, :date, :qr_code_uuid, :description)
    end
  end
end
