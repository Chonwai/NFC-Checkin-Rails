# frozen_string_literal: true

module Api
  class TempUsersController < ApplicationController
    before_action :set_activity

    def create
      device_id = temp_user_params[:device_id]

      if device_id.present?
        temp_user = @activity.temp_users.find_or_initialize_by(device_id:)

        unless temp_user.persisted?
          temp_user.is_temporary = true
          temp_user.meta = { device_id: }
          # 生成一個唯一的 UUID 作為 TempUser 的 UUID
          temp_user.uuid = SecureRandom.uuid
        end

        if temp_user.save
          render json: {
            temp_user:,
            token: temp_user.uuid
          }, status: :created
        else
          render json: { errors: temp_user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: '裝置識別符缺失' }, status: :bad_request
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
