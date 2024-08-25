# frozen_string_literal: true

require 'json'

# Service used to manager redis cache
class CacheService
  def initialize(url = ENV['REDIS_URL'])
    @redis = Redis.new(url:)
  end

  def store(key, value)
    @redis.set(key, value.map(&:to_json), ex: 60)
  end

  def recover(key)
    serialized = @redis.get(key)
    array = JSON.parse(serialized) if serialized
    array&.map { |item| JSON.parse(item, symbolize_names: true) }
  end
end
