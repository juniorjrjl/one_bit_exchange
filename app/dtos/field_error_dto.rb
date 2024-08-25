# frozen_string_literal: true

# Class with information about fields with error in request
class FieldErrorDto
  attr_reader :field, :error_message

  def initialize(field, error_message)
    @field = field
    @error_message = error_message
  end
end
