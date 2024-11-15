# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  include ApiResponse

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
  rescue_from StandardError, with: :handle_standard_error

  private

  def handle_not_found(exception)
    api_error(
      exception.message,
      ErrorCodes::RECORD_NOT_FOUND
    )
  end

  def handle_validation_error(exception)
    api_error(
      exception.message,
      ErrorCodes::VALIDATION_ERROR,
      exception.record.errors.full_messages
    )
  end

  def handle_standard_error(exception)
    Rails.logger.error("未預期的錯誤: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))

    api_error(
      '系統發生錯誤',
      ErrorCodes::SYSTEM_ERROR
    )
  end
end
