# frozen_string_literal: true

module Api
  class TempUsersController < ApplicationController
    before_action :set_activity

    def create
      device_id = request.headers['X-Temp-User-Token']

      if device_id.present?
        temp_user = @activity.temp_users.find_or_initialize_by(device_id:)

        unless temp_user.persisted?
          temp_user.is_temporary = true
          temp_user.meta = { device_id: }
        end

        if temp_user.save
          api_success({ temp_user: }, :created)
        else
          api_error('臨時用戶創建失敗', :unprocessable_entity, temp_user.errors.full_messages)
        end
      else
        api_error('裝置識別符缺失', :bad_request, code: ErrorCodes::VALIDATION_ERROR)
      end
    end

    private

    def set_activity
      @activity = Activity.find(params[:activity_id])
    end

    def temp_user_params
      params.require(:temp_user).permit(:device_id)
    end
  end
end
