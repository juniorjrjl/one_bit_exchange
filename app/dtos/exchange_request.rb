# frozen_string_literal: true

class ExchangeRequest
  include ActiveModel::Model

  attr_accessor :source, :target, :amount

  validates :source, presence: true

  validates :target, presence: true

  validates :amount, presence: true, numericality: true
end
