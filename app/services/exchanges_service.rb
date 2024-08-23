# frozen_string_literal: true

require 'json'

class ExchangesService
  def initialize(rest_service = RestService.new, redis = $redis)
    @rest_service = rest_service
    @redis = redis
  end

  def convert(dto)
    valid_symbol(dto.source, [[I18n.t('exchange_request.source.unknow', symbol: dto.source), 'source']])

    valid_symbol(dto.target, [[I18n.t('exchange_request.target.unknow', symbol: dto.target), 'target']])

    rates = @rest_service.convert(dto.target, dto.source)
    usd_amount = dto.amount
    usd_base = rates['USD'].to_f
    usd_amount = to_another_currency(rates[dto.source].to_f, dto.amount, usd_base) if dto.source != 'USD'

    return usd_amount if dto.target == 'USD'

    to_another_currency(usd_base, usd_amount, rates[dto.target].to_f)
  end

  def available
    symbols = recover_symbols
    return symbols if symbols

    recovered = @rest_service.currencies.map { |k, v| AvailableDto.new(k, v) }
    store_symbols(recovered)
    recovered.sort_by(&:description)
  end

  private

  def to_another_currency(source_base, source_valeu, target_base)
    (source_valeu * target_base) / source_base
  end

  def store_symbols(symbols)
    serialized_symbols = Marshal.dump(symbols)
    @redis.set('symbols', serialized_symbols, ex: 60)
  end

  def recover_symbols
    serialized_symbols = @redis.get('symbols')
    Marshal.load(serialized_symbols) if serialized_symbols
  end

  def valid_symbol(symbol, error_info)
    symbols = available
    return nil if symbols.any? { |s| s.symbol == symbol }

    message = I18n.t('errors.exchange')
    raise ModelConstraintError.new(message, error_info)
  end
end
