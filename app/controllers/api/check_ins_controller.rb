# frozen_string_literal: true

module Api
  class CheckInsController < ApplicationController
    before_action :authorize_temp_user

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

    def authorize_temp_user
      @current_temp_user = TempUser.find_by(uuid: request.headers['X-Temp-User-Token'])
      return if @current_temp_user

      render json: { error: '未授權的臨時用戶' }, status: :unauthorized
    end
  end
end
