# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_request do
    target { FFaker::Currency.code }
    source { FFaker::Currency.code }
    amount { FFaker::Number.decimal }

    initialize_with { new(target:, source:, amount:) }
  end
end
