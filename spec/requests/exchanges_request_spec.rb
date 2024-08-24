# frozen_string_literal: true

require 'rails_helper'
require 'net/http'
require 'json'

RSpec.describe 'Exchanges', type: :request do
  describe 'happy scenary' do
    context 'GET #available' do
      let(:symbols) { build_list(:available_dto, 5) }

      before do
        response = { 'currencySymbols' => symbols.each_with_object({}) { |d, m| m[d.symbol] = d.description } }.to_json
        allow(Net::HTTP).to receive(:get).with(URI('http://fakecurrency.com/currency-symbols')).and_return(response)
        get '/exchanges/available'
        get '/exchanges/available'
      end

      after do
        Redis.new(url: ENV['REDIS_URL']).del('symbols')
      end

      it 'then http status is ok' do
        expect_status_is_ok
      end

      it 'mock called one time' do
        expect(Net::HTTP).to have_received(:get).exactly(1).times
      end

      it 'response have available currencies' do
        symbols.each do |s|
          expect(response.body).to include(s.symbol)
          expect(response.body).to include(s.description)
        end
      end
    end

    context 'GET #convert' do
      let(:symbols) { build_list(:available_dto, 5) }

      before do
        available_res = { 'currencySymbols' => symbols.each_with_object({}) do |d, m|
                                                 m[d.symbol] = d.description
                                               end }.to_json
        allow(Net::HTTP).to receive(:get).with(URI('http://fakecurrency.com/currency-symbols')).and_return(available_res)

        target = symbols[0].symbol
        source = symbols[4].symbol
        convert_res = { 'rates' => { 'USD' => '1.00', source => '2.00', target => '3.0' } }.to_json
        convert_uri = URI("http://fakecurrency.com/rates/latest?apikey=api_key&symbols=#{target},#{source},USD")
        allow(Net::HTTP).to receive(:get).with(convert_uri).and_return(convert_res)
        get "/exchanges/convert?source=#{source}&target=#{target}&amount=2"
      end

      after do
        Redis.new(url: ENV['REDIS_URL']).del('symbols')
      end

      it 'then http status is ok' do
        expect_status_is_ok
      end

      it 'body have a converted value' do
        expect(response.body).to include('3.0')
      end

      it 'mock available symbols called one time' do
        expect(Net::HTTP).to have_received(:get).with(URI('http://fakecurrency.com/currency-symbols')).exactly(1).times
      end

      it 'mock convert called one time' do
        uri = "http://fakecurrency.com/rates/latest?apikey=api_key&symbols=#{symbols[0].symbol},#{symbols[4].symbol},USD"
        expect(Net::HTTP).to have_received(:get).with(URI(uri)).exactly(1).times
      end
    end
  end

  describe 'unhappy scenary' do
    before do
      available_res = { 'currencySymbols' => { 'USD' => 'dollar', 'JPY' => 'yenni', 'BRL' => 'real' } }.to_json
      allow(Net::HTTP).to receive(:get).with(URI('http://fakecurrency.com/currency-symbols')).and_return(available_res)
    end

    after do
      Redis.new(url: ENV['REDIS_URL']).del('symbols')
    end

    context 'invalid params' do
      [
        { target: '   ', source: 'USD', amount: 1.00 },
        { target: 'AAA', source: 'USD', amount: 1.00 },
        { target: 'USD', source: '   ', amount: 1.00 },
        { target: 'USD', source: 'AAA', amount: 1.00 },
        { target: 'BRL', source: 'JPY', amount: nil },
        { target: 'JPY', source: 'BRL', amount: '1a' }
      ].each do |params|
        it "request using follow params #{params}" do
          get "/exchanges/convert?source=#{params[:target]}&target=#{params[:source]}&amount=#{params[:amount]}"
          expect_status_is_bad_request
        end
      end
    end
  end
end
