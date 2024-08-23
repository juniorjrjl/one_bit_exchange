# frozen_string_literal: true

class ModelConstraintError < OneBitExchangeError
  attr_reader :errors

  def initialize(message, errors)
    super(message)
    @errors = errors
  end
end
