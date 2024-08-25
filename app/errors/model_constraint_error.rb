# frozen_string_literal: true

# Error raised when happen some constraint violation in request
class ModelConstraintError < OneBitExchangeError
  attr_reader :errors

  def initialize(message, errors)
    super(message)
    @errors = errors
  end
end
