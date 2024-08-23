# frozen_string_literal: true

class FieldErrorDto
  attr_reader :field, :error_message

  def initialize(field, error_message)
    @field = field
    @error_message = error_message
  end
end
