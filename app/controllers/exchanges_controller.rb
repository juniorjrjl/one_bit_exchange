# frozen_string_literal: true

# Controller to receive requests about exchange
class ExchangesController < ApplicationController
  def initialize(validations_service = ValidationsService.new, exchanges_service = ExchangesService.new)
    super()
    @validations_service = validations_service
    @exchanges_service = exchanges_service
  end

  def convert
    request = ExchangeRequest.new(exchange_request_params)
    @validations_service.validate(request, I18n.t('errors.exchange'))

    dto = ExchangeDto.new(request.target, request.source, request.amount)
    @response = @exchanges_service.convert(dto)
  end

  def available
    @response = @exchanges_service.available
  end

  private

  def exchange_request_params
    params.permit(:source, :target, :amount)
  end
end
