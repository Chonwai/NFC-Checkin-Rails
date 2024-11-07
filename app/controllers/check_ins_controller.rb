class CheckInsController < ApplicationController
  before_action :authorize

  def create
    check_in = CheckIn.new(check_in_params)
    check_in.checkin_time = Time.current

    if check_in.save
      # 發放獎勵
      RewardService.new(check_in.user).grant_reward
      render json: check_in, status: :created
    else
      render json: { errors: check_in.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    check_ins = CheckIn.where(user: @current_user)
    render json: check_ins
  end

  private

  def check_in_params
    params.require(:check_in).permit(:location_id)
  end
end
