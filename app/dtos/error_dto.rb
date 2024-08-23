# frozen_string_literal: true

class ErrorDto
  attr_reader :status, :message, :field_errors

  private_class_method :new

  def self.internal_server_error(message)
    new(500, message)
  end

  def self.bad_request(message, field_errors = nil)
    new(400, message, field_errors)
  end

  def initialize(status, message, field_errors = nil)
    @status = status
    @message = message
    @field_errors = field_errors
  end
end
