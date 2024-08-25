# frozen_string_literal: true

require 'net/http'
require 'json'

# Service to call endpoints from CurrencyFreaks api
class RestService
  def initialize(base_path = ENV['EXCHANGE_BASE_PATH'], api_key = ENV['EXCHANGE_API_KEY'])
    @base_path = base_path
    @api_key = api_key
  end

  def currencies
    uri = URI("#{@base_path}currency-symbols")
    response = Net::HTTP.get(uri)
    JSON.parse(response)['currencySymbols']
  end

  def convert(target, source)
    uri = URI("#{@base_path}rates/latest?apikey=#{@api_key}&symbols=#{target},#{source},USD")
    response = Net::HTTP.get(uri)
    JSON.parse(response)['rates']
  end
end
