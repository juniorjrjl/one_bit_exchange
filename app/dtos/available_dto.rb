# frozen_string_literal: true

class AvailableDto
  attr_reader :symbol, :description

  def initialize(symbol, description)
    @symbol = symbol
    @description = description
  end
end
