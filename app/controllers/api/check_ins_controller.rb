# frozen_string_literal: true

module Api
  class CheckInsController < ApplicationController
    before_action :authorize_or_create_temp_user, only: %i[create]
    before_action :set_current_temp_user, only: %i[index index_with_activity show]
    before_action :validate_redirect_token, only: %i[create]

    def index
      api_success(check_ins: @current_temp_user.check_ins)
    end

    def index_with_activity
      check_ins = @current_temp_user.check_ins.includes(:location)
      formatted_check_ins = check_ins.map do |check_in|
        {
          id: check_in.id,
          check_in:,
          location: check_in.location,
          activity: check_in.activity
        }
      end
      api_success(check_ins: formatted_check_ins)
    end

    def show
      check_in = @current_temp_user.check_ins.find(params[:id])
      api_success(check_in:)
    end

    def create
      check_in = @current_temp_user.check_ins.build(check_in_params)
      check_in.checkin_time = Time.current

      if check_in.save
        begin
          api_success({ check_in: }, :created)
        rescue StandardError => e
          api_success(
            { check_in:, reward_error: e.message },
            :created
          )
        end
      else
        api_error('打卡失敗', :unprocessable_entity, check_in.errors.full_messages)
      end
    end

    def generate_token
      activity_id = params[:activity_id]
      location_id = params[:location_id]

      activity = Activity.find_by(id: activity_id, is_active: true)
      location = Location.find_by(id: location_id, activity_id:)

      return api_error('無效的活動或地點', ErrorCodes::INVALID_LOCATION) unless activity && location

      payload = { activity_id: activity.id, location_id: location.id, exp: 10.minutes.from_now.to_i }
      token = JWT.encode(payload, Rails.application.secret_key_base, 'HS256')

      api_success({ token: }, :ok)
    end

    private

    def check_in_params
      params.require(:check_in).permit(:location_id)
    end

    def set_current_temp_user
      device_id = request.headers['X-Temp-User-Token']
      @current_temp_user = TempUser.find_by(device_id:)
      api_error('你還沒有參與任何活動', :unauthorized, code: ErrorCodes::UNAUTHORIZED) unless @current_temp_user
    end

    def authorize_or_create_temp_user
      device_id = request.headers['X-Temp-User-Token']
      activity_id = params.dig(:check_in, :activity_id)

      if device_id.present? && activity_id.present?
        @current_temp_user = TempUser.find_or_create_by(device_id:, activity_id:) do |temp_user|
          temp_user.is_temporary = true
          temp_user.meta = { device_id: }
        end
        return if @current_temp_user
      end

      api_error('未授權的臨時用戶', ErrorCodes::UNAUTHORIZED)
    end

    def validate_redirect_token
      token = params[:token]
      decoded = begin
        JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      rescue StandardError
        nil
      end

      if decoded.present?
        payload = decoded.first
        @activity_id = payload['activity_id']
        @location_id = payload['location_id']
      else
        api_error('無效的令牌', ErrorCodes::UNAUTHORIZED)
      end
    end
  end
end
