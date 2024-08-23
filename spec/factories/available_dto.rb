# frozen_string_literal: true

FactoryBot.define do
  factory :available_dto do
    symbol { FFaker::Currency.code }
    description { FFaker::Currency.name }

    initialize_with { new(symbol, description) }
  end
end
