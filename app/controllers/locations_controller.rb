class LocationsController < ApplicationController
  before_action :authorize
  before_action :set_activity
  before_action :set_location, only: %i[show update destroy]

  def index
    render json: @activity.locations
  end

  def show
    render json: @location
  end

  def create
    location = @activity.locations.build(location_params)
    if location.save
      render json: location, status: :created
    else
      render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      render json: @location
    else
      render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    head :no_content
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '活動未找到' }, status: :not_found
  end

  def set_location
    @location = @activity.locations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '地點未找到' }, status: :not_found
  end

  def location_params
    params.require(:location).permit(:address, :location_uuid, :description)
  end
end
