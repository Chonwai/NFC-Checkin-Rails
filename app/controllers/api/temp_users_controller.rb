# frozen_string_literal: true

class TempUsersController < ApplicationController
  def create
    activity = Activity.find(params[:activity_id])
    temp_user = activity.temp_users.new(temp_user_params)

    if temp_user.save
      render json: {
        temp_user:,
        token: temp_user.uuid
      }, status: :created
    else
      render json: { errors: temp_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def temp_user_params
    params.require(:temp_user).permit(:phone, :email)
  end
end
