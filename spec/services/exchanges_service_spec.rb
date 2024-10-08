# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangesService, type: :service do
  let(:rest_service) { double(RestService) }
  let(:redis) { double(CacheService) }
  let(:service) { described_class.new(rest_service, redis) }

  context 'get available symbols' do
    let(:symbols) { build_list(:available_dto, 5) }

    context 'get from redis cache' do
      before do
        cache_json = symbols.map(&:to_h)
        expect(redis).to receive(:recover).with('symbols').and_return(cache_json)
        allow(rest_service).to receive(:currencies)
      end

      it 'recover available' do
        actual = service.available
        expect_field_by_field_list(actual, symbols, %i[symbol description])
        expect(rest_service).not_to have_received(:currencies)
      end
    end

    context 'get from api' do
      before do
        availables = symbols.each_with_object({}) { |d, m| m[d.symbol] = d.description }
        allow(rest_service).to receive(:currencies).and_return(availables)
        allow(redis).to receive(:recover).with('symbols').and_return(nil)
        allow(redis).to receive(:store).with('symbols', anything)
      end

      it 'recover available' do
        actual = service.available
        expect_field_by_field_list(actual, symbols.sort_by(&:description), %i[symbol description])
        expect(redis).to have_received(:recover)
        expect(redis).to have_received(:store)
      end
    end
  end

  context 'convert value to another' do
    let(:symbols) do
      [build(:available_dto, symbol: 'USD'), build(:available_dto, symbol: 'EUR'), build(:available_dto, symbol: 'JPY')]
    end

    before do
      allow(redis).to receive(:recover).with('symbols').and_return(symbols.map(&:to_h))
    end

    context 'has a unknow symbol' do
      [
        { valid_field: :target, invalid_field: :source },
        { valid_field: :source, invalid_field: :target }
      ].each do |params|
        it 'use dto with invalid symbol' do
          valid_field = params[:valid_field]
          invalid_field = params[:invalid_field]
          dto = build(:exchange_dto, valid_field => symbols[0].symbol, invalid_field => 'BRL')
          expect { service.convert(dto) }.to raise_error(ModelConstraintError) { |er|
                                               expect(er.errors[0][1]).to eq(invalid_field.to_s)
                                             }
          expect(redis).to have_received(:recover).exactly(1).times
        end
      end
    end

    context 'convert non dollar currency to another non dollar' do
      it 'receive converted' do
        allow(rest_service).to receive(:convert).with('EUR',
                                                      'JPY').and_return({ 'USD' => '1.00', 'JPY' => '2.00',
                                                                          'EUR' => '3.00' })
        dto = ExchangeDto.new('EUR', 'JPY', 2.00)
        actual = service.convert(dto)
        expect(actual).to eq(3)
      end
    end

    context 'convert non dollar currency to dollar' do
      it 'receive converted' do
        allow(rest_service).to receive(:convert).with('USD',
                                                      'JPY').and_return({ 'USD' => '1.00', 'JPY' => '2.00',
                                                                          'EUR' => '3.00' })
        dto = ExchangeDto.new('USD', 'JPY', 2.00)
        actual = service.convert(dto)
        expect(actual).to eq(1)
      end
    end

    context 'convert dollar currency to another non dollar' do
      it 'receive converted' do
        allow(rest_service).to receive(:convert).with('EUR',
                                                      'USD').and_return({ 'USD' => '1.00', 'JPY' => '2.00',
                                                                          'EUR' => '3.00' })
        dto = ExchangeDto.new('EUR', 'USD', 1.00)
        actual = service.convert(dto)
        expect(actual).to eq(3)
      end
    end
  end
end
