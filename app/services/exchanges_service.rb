# frozen_string_literal: true

class ExchangesService
  def initialize(rest_service = RestService.new, cache_service = CacheService.new)
    @rest_service = rest_service
    @cache_service = cache_service
  end

  def convert(dto)
    check_symbols(dto)
    rates = retrieve_base_values(dto.target, dto.source)
    convert_to_target(dto, rates)
  end

  def available
    symbols = @cache_service.recover('symbols')
    return symbols.map { |symbol| AvailableDto.from_h(symbol) } if symbols

    recovered = @rest_service.currencies.map { |k, v| AvailableDto.new(k, v) }
    @cache_service.store('symbols', recovered.map(&:to_h))
    recovered.sort_by(&:description)
  end

  private

  def retrieve_base_values(target, source)
    @rest_service.convert(target, source)
  end

  def convert_to_target(dto, rates)
    dollar_amount = to_dollar(dto.amount, dto.source, rates[dto.source].to_f, rates['USD'].to_f)

    to_target(dto.target, dollar_amount, rates['USD'].to_f, rates[dto.target].to_f)
  end

  def to_dollar(amount, source, source_base, dollar_base)
    return amount if source == 'USD'

    to_another_currency(source_base, amount, dollar_base)
  end

  def to_target(target, amount, dollar_base, target_base)
    return amount if target == 'USD'

    to_another_currency(dollar_base, amount, target_base)
  end

  def to_another_currency(source_base, source_valeu, target_base)
    (source_valeu * target_base) / source_base
  end

  def check_symbols(dto)
    symbols = available
    fields = %i[source target]
    fields.each do |field|
      symbol = dto.send(field)
      next if symbols.any? { |s| s.symbol == symbol }

      message = I18n.t('errors.exchange')
      error_info = [[I18n.t("exchange_request.#{field}.unknow", symbol:), field.to_s]]
      raise ModelConstraintError.new(message, error_info)
    end
  end
end
