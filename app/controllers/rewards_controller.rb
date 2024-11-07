class RewardsController < ApplicationController
  before_action :authorize_temp_user

  def index
    rewards = @current_temp_user.rewards
    render json: rewards
  end

  def show
    reward = @current_temp_user.rewards.find(params[:id])
    render json: reward
  rescue ActiveRecord::RecordNotFound
    render json: { error: '獎勵未找到' }, status: :not_found
  end

  def update
    reward = @current_temp_user.rewards.find(params[:id])
    if reward.update(reward_params)
      render json: reward
    else
      render json: { errors: reward.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: '獎勵未找到' }, status: :not_found
  end

  private

  def reward_params
    params.require(:reward).permit(:redeemed)
  end

  def authorize_temp_user
    @current_temp_user = TempUser.find_by(uuid: request.headers['X-Temp-User-Token'])
    return if @current_temp_user

    render json: { error: '未授權的臨時用戶' }, status: :unauthorized
  end
end
