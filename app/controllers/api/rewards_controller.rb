# frozen_string_literal: true

module Api
  class RewardsController < ApplicationController
    before_action :authorize_temp_user

    def index
      rewards = @current_temp_user.rewards
      render json: {
        success: true,
        rewards:
      }
    end

    def show
      reward = @current_temp_user.rewards.find(params[:id])
      render json: {
        success: true,
        reward:
      }
    rescue ActiveRecord::RecordNotFound
      render json: {
        success: false,
        error: '獎勵未找到'
      }, status: :not_found
    end

    def update
      reward = @current_temp_user.rewards.find(params[:id])
      if reward.update(reward_params)
        render json: {
          success: true,
          reward:
        }
      else
        render json: {
          success: false,
          errors: reward.errors.full_messages
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {
        success: false,
        error: '獎勵未找到'
      }, status: :not_found
    end

    private

    def reward_params
      params.require(:reward).permit(:redeemed)
    end

    def authorize_temp_user
      device_id = request.headers['X-Temp-User-Token']
      @current_temp_user = TempUser.find_by(device_id:)

      return if @current_temp_user

      render json: { error: '未授權的臨時用戶' }, status: :unauthorized
    end
  end
end
