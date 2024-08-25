# frozen_string_literal: true

# Main controller with exception handler
class ApplicationController < ActionController::API
  rescue_from Exception do |e|
    logger.error "==== Exception: #{e.backtrace.join("\n")}"
    logger.error "==== Details: #{e.message}"
    @problem = ErrorDto.internal_server_error(I18n.t('errors.generic'))
    render 'errors/error', status: :internal_server_error
  end

  rescue_from OneBitExchangeError do |e|
    logger.error "==== OneBitExchangeError: #{e.backtrace.join("\n")}"
    logger.error "==== Details: #{e.message}"
    @problem = ErrorDto.internal_server_error(I18n.t('errors.generic'))
    render 'errors/error', status: :internal_server_error
  end

  rescue_from ModelConstraintError do |e|
    logger.error "==== ModelConstraintError: #{e.backtrace.join("\n")}"
    logger.error "==== Details: #{e.message}"
    field_errors = e.errors.map { |k, v| FieldErrorDto.new(v, k) }
    @problem = ErrorDto.bad_request(e.message, field_errors)
    render 'errors/error', status: :bad_request
  end
end
