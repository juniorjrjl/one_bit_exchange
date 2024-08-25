# frozen_string_literal: true

require 'rails_helper'
require 'net/http'
require 'json'

RSpec.describe 'Exchanges', type: :request do
  context 'GET #convert' do
    let(:symbols) { build_list(:available_dto, 5) }

    before do
      response = { 'currencySymbols' => symbols.each_with_object({}) { |d, m| m[d.symbol] = d.description } }.to_json
      allow(Net::HTTP).to receive(:get).with(URI('http://fakecurrency.com/currency-symbols')).and_return(response)
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

    it 'then response has none errors' do
      expect_status_is_ok
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
