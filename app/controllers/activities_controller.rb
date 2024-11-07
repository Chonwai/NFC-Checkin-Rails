class ActivitiesController < ApplicationController
  include AdminAuthenticator
  before_action :set_activity, only: %i[show update destroy]

  def index
    activities = Activity.all
    render json: activities
  end

  def show
    render json: @activity
  end

  def create
    activity = Activity.new(activity_params)
    if activity.save
      render json: activity, status: :created
    else
      render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @activity.update(activity_params)
      render json: @activity
    else
      render json: { errors: @activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy
    head :no_content
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '活動未找到' }, status: :not_found
  end

  def activity_params
    params.require(:activity).permit(:name, :date, :qr_code_uuid, :description)
  end
end
