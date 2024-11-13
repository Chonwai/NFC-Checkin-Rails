# frozen_string_literal: true

module Api
  class CheckInsController < ApplicationController
    before_action :authorize_or_create_temp_user

    def create
      check_in = @current_temp_user.check_ins.build(check_in_params)
      check_in.checkin_time = Time.current

      if check_in.save
        begin
          # 發放獎勵
          reward = RewardService.new(@current_temp_user).grant_reward
          render json: {
            check_in:,
            reward:
          }, status: :created
        rescue StandardError => e
          # 打卡成功但獎勵發放失敗
          render json: {
            check_in:,
            reward_error: e.message
          }, status: :created
        end
      else
        render json: { errors: check_in.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def index
      check_ins = @current_temp_user.check_ins
      render json: check_ins
    end

    private

    def check_in_params
      params.require(:check_in).permit(:location_id)
    end

    def authorize_or_create_temp_user
      token = request.headers['X-Temp-User-Token']
      device_id = params[:device_id]

      if token.present?
        @current_temp_user = TempUser.find_by(uuid: token)
      elsif device_id.present?
        @current_temp_user = TempUser.find_or_create_by(device_id:,
                                                        activity_id: params[:activity_id]) do |temp_user|
          temp_user.is_temporary = true
          temp_user.meta = { device_id: }
          temp_user.uuid = SecureRandom.uuid
        end
      end

      return if @current_temp_user

      render json: { error: '未授權的臨時用戶' }, status: :unauthorized
    end
  end
end
