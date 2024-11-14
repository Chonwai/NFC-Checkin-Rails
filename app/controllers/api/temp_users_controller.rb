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
          render json: {
            success: true,
            temp_user:
          }, status: :created
        else
          render json: {
            success: false,
            errors: temp_user.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        render json: {
          success: false,
          error: '裝置識別符缺失'
        }, status: :bad_request
      end
    end

    private

    def set_activity
      @activity = Activity.find(params[:activity_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: '活動未找到' }, status: :not_found
    end

    def temp_user_params
      params.require(:temp_user).permit(:device_id)
    end
  end
end
