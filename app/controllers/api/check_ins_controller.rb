# frozen_string_literal: true

module Api
  class CheckInsController < ApplicationController
    before_action :authorize_or_create_temp_user, only: %i[create]
    before_action :set_current_temp_user, only: %i[index index_with_activity show]

    def index
      check_ins = @current_temp_user.check_ins
      render json: {
        success: true,
        check_ins:
      }
    end

    def index_with_activity
      check_ins = @current_temp_user.check_ins.includes(:location)
      puts @current_temp_user.check_ins
      render json: {
        success: true,
        check_ins: check_ins.map do |check_in|
          {
            id: check_in.id,
            check_in:,
            location: check_in.location,
            activity: check_in.activity
          }
        end
      }
    end

    def show
      check_in = @current_temp_user.check_ins.find(params[:id])
      render json: {
        success: true,
        check_in:
      }
    end

    def create
      check_in = @current_temp_user.check_ins.build(check_in_params)
      check_in.checkin_time = Time.current

      if check_in.save
        begin
          reward = RewardService.new(@current_temp_user).grant_reward
          render json: {
            success: true,
            check_in:,
            reward:
          }, status: :created
        rescue StandardError => e
          render json: {
            success: true,
            check_in:,
            reward_error: e.message
          }, status: :created
        end
      else
        render json: {
          success: false,
          errors: check_in.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def check_in_params
      params.require(:check_in).permit(:location_id)
    end

    def set_current_temp_user
      device_id = request.headers['X-Temp-User-Token']
      @current_temp_user = TempUser.find_by(device_id:)
    end

    def authorize_or_create_temp_user
      device_id = request.headers['X-Temp-User-Token']

      if device_id.present
        @current_temp_user = TempUser.find_or_create_by(device_id:, activity_id: params[:activity_id]) do |temp_user|
          temp_user.is_temporary = true
          temp_user.meta = { device_id: }
        end
      end

      return if @current_temp_user

      render json: { error: '未授權的臨時用戶' }, status: :unauthorized
    end
  end
end
