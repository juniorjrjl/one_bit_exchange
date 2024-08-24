# frozen_string_literal: true

json.array! @response do |r|
  json.symbol r.symbol
  json.description r.description
end
