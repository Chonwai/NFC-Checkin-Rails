# frozen_string_literal: true

module Api
  class RewardsController < ApplicationController
    before_action :authorize_temp_user
    before_action :set_reward, only: %i[show update]

    def index
      api_success(rewards: @current_temp_user.rewards)
    end

    def show
      api_success(reward: @reward)
    end

    def update
      if @reward.update(reward_params)
        api_success(reward: @reward)
      else
        api_error('獎勵更新失敗', :unprocessable_entity, @reward.errors.full_messages)
      end
    end

    def query_rewards
      result = @current_temp_user.activity.get_user_rewards(@current_temp_user.id)

      if result[:success]
        api_success(rewards: result[:data])
      else
        api_error(result[:error], :service_unavailable)
      end
    end

    private

    def reward_params
      params.require(:reward).permit(:redeemed)
    end

    def set_reward
      @reward = @current_temp_user.rewards.find(params[:id])
    end

    def authorize_temp_user
      device_id = request.headers['X-Temp-User-Token']
      @current_temp_user = TempUser.find_by(device_id:)

      return if @current_temp_user

      api_error('未授權的臨時用戶', :unauthorized, code: ErrorCodes::UNAUTHORIZED)
    end
  end
end
