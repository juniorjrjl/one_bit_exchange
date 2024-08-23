# frozen_string_literal: true

class ExchangeDto
  attr_reader :source, :target, :amount

  def initialize(target, source, amount)
    @target = target
    @source = source
    @amount = amount.to_f
  end
end
