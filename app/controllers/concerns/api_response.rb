# frozen_string_literal: true

module ApiResponse
  extend ActiveSupport::Concern

  def api_success(data = {}, _status = :ok)
    render json: {
      success: true,
      data:
    }, status: :ok
  end

  def api_error(message, error_code, details = nil)
    response = {
      success: false,
      error: {
        message:,
        code: error_code
      }
    }
    response[:error][:details] = details if details.present?

    render json: response, status: :ok
  end
end
