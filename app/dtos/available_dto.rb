# frozen_string_literal: true

# DTO for return availables currencies
class AvailableDto
  attr_reader :symbol, :description

  def initialize(symbol, description)
    @symbol = symbol
    @description = description
  end

  def to_h
    { symbol: @symbol, description: @description }
  end

  def self.from_h(hash)
    new(hash[:symbol], hash[:description])
  end
end
